const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

// Firebase Admin SDK 초기화 (서비스 계정 키 파일 사용)
if (!admin.apps.length) {
  const serviceAccount = require("./handy-talk-firebase-adminsdk.json");
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

exports.kakaoCustomAuth = functions.https.onRequest(async (req, res) => {
  const kakaoAccessToken = req.body.accessToken;
  if (!kakaoAccessToken) {
    return res.status(400).send("No Kakao access token provided");
  }

  try {
    // 1. 카카오 accessToken으로 사용자 정보 조회
    const kakaoUser = await axios.get("https://kapi.kakao.com/v2/user/me", {
      headers: {Authorization: `Bearer ${kakaoAccessToken}`},
    });

    const kakaoId = kakaoUser.data.id.toString();
    const email = kakaoUser.data.kakao_account &&
      kakaoUser.data.kakao_account.email ?
      kakaoUser.data.kakao_account.email : "";
    const nickname = kakaoUser.data.properties &&
      kakaoUser.data.properties.nickname ?
      kakaoUser.data.properties.nickname : "";
    const profileImage = kakaoUser.data.properties &&
      kakaoUser.data.properties.profile_image ?
      kakaoUser.data.properties.profile_image : "";

    // 2. Firebase Custom Token 생성 (더 많은 정보 포함)
    const firebaseUid = `kakao:${kakaoId}`;
    const customToken = await admin.auth().createCustomToken(
        firebaseUid,
        {
          email: email,
          nickname: nickname,
          profileImage: profileImage,
          provider: "kakao",
        },
    );

    return res.json({customToken});
  } catch (error) {
    console.error("Error details:", error);
    console.error("Error code:", error.code);
    console.error("Error message:", error.message);

    if (error.code === "auth/insufficient-permission") {
      return res.status(500).send(
          "Firebase Admin SDK permission error",
      );
    }

    if (error.code === "app/no-app") {
      return res.status(500).send("Firebase Admin SDK not initialized");
    }

    return res.status(500).send("Kakao auth failed: " + error.message);
  }
});
