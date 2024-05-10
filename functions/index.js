// /**
//  * Import function triggers from their respective submodules:
//  *
//  * const {onCall} = require("firebase-functions/v2/https");
//  * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
//  *
//  * See a full list of supported triggers at https://firebase.google.com/docs/functions
//  */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started

// // exports.helloWorld = onRequest((request, response) => {
// //   logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");
// // });

// モジュールのロードおよびインスタンスに代入
const functions = require("firebase-functions");
const express = require("express");
const basicAuth = require("basic-auth-connect");
const path = require("path");
const app = express();

// Basic認証のデータを定義
const loginUserName = "hi";
const loginPassword = "hi";

// すべてのリクエスト(app.all)かつすべてのパス('/*') に対してBasic認証をかける
// 特定のパスに関してかける場合は /* を /hoge/* などにかえる
// app.all(
//   "/*",
//   basicAuth(
//     (user, password) => user === loginUserName && password === loginPassword
//   )
// );

// 静的配信をするファイルのパスを指定する。今回はstaticを指定。
// app.use(express.static(__dirname + "/static/index.html"));

app.use(express.static(path.join(__dirname, "static")));

app.use((req, res) => {
  res.sendFile(path.join(__dirname, "static", "index.html"));
});

// node,jsのexportsで、app関数として呼び出せるように設定
exports.app = functions.region("asia-northeast1").https.onRequest(app);
