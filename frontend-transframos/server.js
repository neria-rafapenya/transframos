import express from "express";
import http from "node:http";
import { createProxyMiddleware } from "http-proxy-middleware";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const port = Number(process.env.PORT) || 5200;
const target =
  process.env.API_PROXY_TARGET || "http://localhost:3000";

app.set("trust proxy", true);

const proxyConfig = {
  target,
  changeOrigin: true,
  ws: true,
  secure: process.env.PROXY_SECURE !== "false",
  logLevel: process.env.PROXY_LOG_LEVEL || "warn",
};

const rewriteToOriginalUrl = (path, req) => req.originalUrl || path;

const apiProxy = createProxyMiddleware({
  ...proxyConfig,
  pathRewrite: rewriteToOriginalUrl,
});
const handoffProxy = createProxyMiddleware({
  ...proxyConfig,
  pathRewrite: rewriteToOriginalUrl,
});
const socketProxy = createProxyMiddleware({
  ...proxyConfig,
  pathRewrite: rewriteToOriginalUrl,
});

app.use(
  "/api",
  apiProxy,
);
app.use(
  "/handoff",
  handoffProxy,
);
app.use(
  "/socket.io",
  socketProxy,
);

const distDir = path.join(__dirname, "dist");
app.use(express.static(distDir, { index: false }));

app.get(/.*/, (_req, res) => {
  res.sendFile(path.join(distDir, "index.html"));
});

const server = http.createServer(app);

server.on("upgrade", socketProxy.upgrade);

server.listen(port, "0.0.0.0", () => {
  console.log(`[frontend] Serving dist on ${port}`);
  console.log(`[frontend] Proxying API to ${target}`);
});
