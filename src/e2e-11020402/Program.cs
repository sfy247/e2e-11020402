var builder = WebApplication.CreateBuilder(args);

// Framework logs as JSON on stdout (warnings and above); request logs come
// from Observability.cs, so every line from this container is parseable
builder.Logging.ClearProviders();
builder.Logging.AddJsonConsole();
builder.Logging.SetMinimumLevel(LogLevel.Warning);

builder.Services.AddHealthChecks();

var app = builder.Build();

// Platform observability: request metrics at /metrics + JSON request logs
app.UseRequestTelemetry();
app.MapMetrics();

app.MapGet("/", () => Results.Json(new
{
    service = "e2e-11020402",
    message = "Hello from e2e-11020402",
}));

// Liveness and readiness for Kubernetes probes
app.MapHealthChecks("/healthz");
app.MapHealthChecks("/readyz");

Observability.Log("info", "starting");
app.Run();
