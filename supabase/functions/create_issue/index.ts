import { serve } from "https://deno.land/std@0.168.0/http/server.ts";


serve(async (req) => {
  const expectedKey = Deno.env.get("API_KEY");
  const receivedKey = req.headers.get("x-api-key");

  if (receivedKey !== expectedKey) {
    return new Response("Unauthorized", { status: 401 });
  }

  const token = Deno.env.get("GITHUB_PAT");
  const url = new URL(req.url);
  const owner = url.searchParams.get("owner") || "";
  const repo = url.searchParams.get("repo") || "";

  const { title, body } = await req.json();

  const githubResponse = await fetch(`https://api.github.com/repos/${owner}/${repo}/issues`, {
    method: "POST",
    headers: {
      Authorization: `token ${token}`,
      Accept: "application/vnd.github+json",
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ title, body }),
  });

  const result = await githubResponse.json();

  return new Response(JSON.stringify(result), {
    headers: { "Content-Type": "application/json" },
    status: githubResponse.status
  });
});
