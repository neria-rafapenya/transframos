import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";
import cssInjectedByJsPlugin from "vite-plugin-css-injected-by-js";

export default defineConfig(({ command, mode }) => {
  const env = loadEnv(mode, process.cwd(), "");
  const buildTarget = (env.VITE_BUILD_TARGET || "widget").toLowerCase();

  const baseConfig = {
    plugins: [react()],
    resolve: {
      tsconfigPaths: true,
    },
    define: {
      __APP_ENV__: JSON.stringify(env.APP_ENV || mode),
    },
  };

  if (command === "serve") {
    return {
      ...baseConfig,
      server: {
        host: "0.0.0.0",
        port: Number(env.PORT) || 5200,
      },
      preview: {
        host: "0.0.0.0",
        port: Number(env.PORT) || 5200,
      },
    };
  }

  if (buildTarget === "app") {
    return {
      ...baseConfig,
      build: {
        outDir: "dist",
        emptyOutDir: true,
        sourcemap: false,
      },
    };
  }

  return {
    ...baseConfig,
    plugins: [react(), cssInjectedByJsPlugin()],
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
