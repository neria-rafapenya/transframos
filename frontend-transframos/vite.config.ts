import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";
import cssInjectedByJsPlugin from "vite-plugin-css-injected-by-js";

export default defineConfig(({ command, mode }) => {
  const env = loadEnv(mode, process.cwd(), "");

  if (command === "serve") {
    return {
      plugins: [react()],
      resolve: {
        tsconfigPaths: true,
      },
      server: {
        host: "0.0.0.0",
        port: Number(env.PORT) || 5200,
      },
      preview: {
        host: "0.0.0.0",
        port: Number(env.PORT) || 5200,
      },
      define: {
        __APP_ENV__: JSON.stringify(env.APP_ENV || mode),
      },
    };
  }

  return {
    plugins: [react(), cssInjectedByJsPlugin()],
    resolve: {
      tsconfigPaths: true,
    },
    define: {
      __APP_ENV__: JSON.stringify(env.APP_ENV || mode),
    },
    build: {
      outDir: "dist",
      emptyOutDir: true,
      sourcemap: false,
      cssCodeSplit: false,
      lib: {
        entry: "src/widget-entry.tsx",
        name: "TransframosWidget",
        formats: ["iife"],
        fileName: () => "index.js",
      },
      rollupOptions: {
        output: {
          inlineDynamicImports: true,
        },
      },
    },
  };
});
