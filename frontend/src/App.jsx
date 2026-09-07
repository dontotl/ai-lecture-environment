import { useEffect, useState } from "react";

export default function App() {
  const [state, setState] = useState("checking");

  useEffect(() => {
    let active = true;

    fetch("/api/health")
      .then(async (response) => {
        if (!response.ok) {
          throw new Error("database unavailable");
        }
        return response.json();
      })
      .then((payload) => {
        if (active) {
          setState(payload.database === "connected" ? "connected" : "unavailable");
        }
      })
      .catch(() => {
        if (active) {
          setState("unavailable");
        }
      });

    return () => {
      active = false;
    };
  }, []);

  const label = state === "connected" ? "DB connected" :
    state === "checking" ? "Checking database" : "DB unavailable";

  return (
    <main>
      <h1>강의환경</h1>
      <p aria-live="polite">{label}</p>
    </main>
  );
}
