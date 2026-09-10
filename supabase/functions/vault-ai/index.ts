import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  try {
    const openAiKey = Deno.env.get("OPENAI_API_KEY");
    if (!openAiKey) throw new Error("OPENAI_API_KEY is not configured in Supabase secrets.");
    const { task = "answer", prompt, context = "", model = "gpt-5.6-luna" } = await req.json();
    if (!prompt) return new Response(JSON.stringify({ error: "prompt is required" }), { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } });
    const instructions = `You are Vault AI, a private knowledge assistant. Task: ${task}. Use the supplied Vault context when relevant. Be concise, factual, and useful. Never invent facts from the user's saved material.\n\nVault context:\n${context}`;
    const response = await fetch("https://api.openai.com/v1/responses", {
      method: "POST",
      headers: { Authorization: `Bearer ${openAiKey}`, "Content-Type": "application/json" },
      body: JSON.stringify({ model, instructions, input: prompt }),
    });
    const data = await response.json();
    if (!response.ok) return new Response(JSON.stringify({ error: data?.error?.message ?? "OpenAI request failed" }), { status: response.status, headers: { ...corsHeaders, "Content-Type": "application/json" } });
    return new Response(JSON.stringify({ text: data.output_text ?? "", model }), { headers: { ...corsHeaders, "Content-Type": "application/json" } });
  } catch (error) {
    return new Response(JSON.stringify({ error: error instanceof Error ? error.message : "Unexpected error" }), { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } });
  }
});
