import express from "express";
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

app.use(
  "/api",
  createProxyMiddleware({
    ...proxyConfig,
    pathRewrite: (path) => `/api${path}`,
  }),
);
app.use(
  "/handoff",
  createProxyMiddleware({
    ...proxyConfig,
    pathRewrite: (path) => `/handoff${path}`,
  }),
);

const distDir = path.join(__dirname, "dist");
app.use(express.static(distDir, { index: false }));

app.get(/.*/, (_req, res) => {
  res.sendFile(path.join(distDir, "index.html"));
});

app.listen(port, "0.0.0.0", () => {
  console.log(`[frontend] Serving dist on ${port}`);
  console.log(`[frontend] Proxying API to ${target}`);
});
