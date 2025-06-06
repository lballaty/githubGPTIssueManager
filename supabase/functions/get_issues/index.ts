import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
//import { serve } from "serve";


serve(async (req) => {
  const expectedKey = Deno.env.get("API_KEY");
  const receivedKey = req.headers.get("x-api-key");

  // 🔍 Log both values to Supabase logs for debugging
    console.log("Expected key:", expectedKey);
    console.log("Received key:", receivedKey);

  if (receivedKey !== expectedKey) {
    return new Response(`App Key Unauthorized\nExpected: ${expectedKey}\nReceived: ${receivedKey}`, { status: 401 });
  }

  const token = Deno.env.get("GITHUB_PAT");

  const url = new URL(req.url);
  const owner = url.searchParams.get("owner") || "flutter";
  const repo = url.searchParams.get("repo") || "flutter";

  const apiUrl = `https://api.github.com/repos/${owner}/${repo}/issues`;
  const response = await fetch(apiUrl, {
    headers: {
      Authorization: `token ${token}`,
      Accept: "application/vnd.github+json",
    },
  });

  const issues = await response.json();

  return new Response(JSON.stringify(issues), {
    headers: { "Content-Type": "application/json" },
  });
});
