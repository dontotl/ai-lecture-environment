import { render, screen } from "@testing-library/react";
import { expect, test, vi } from "vitest";

import App from "./App";

test("shows a connected database status", async () => {
  vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
    ok: true,
    json: async () => ({ status: "ok", database: "connected" }),
  }));

  render(<App />);

  expect(await screen.findByText("DB connected")).toBeInTheDocument();
});
