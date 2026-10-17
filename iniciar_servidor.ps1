# ==============================================================================
# MonitoramentoBoy — Servidor Web Local Nativo (Windows PowerShell)
# Não requer Node.js, Python ou qualquer instalação externa.
# ==============================================================================

$port = 8080
$url = "http://localhost:$port/"
$workspacePath = $PSScriptRoot

Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "       📦 MonitoramentoBoy — Servidor Local de Entregas           " -ForegroundColor Yellow
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "Diretório raiz: $workspacePath" -ForegroundColor Gray
Write-Host "Iniciando servidor HTTP em: $url" -ForegroundColor Green
Write-Host "Pressione Ctrl+C para encerrar o servidor a qualquer momento." -ForegroundColor DarkGray
Write-Host "------------------------------------------------------------------" -ForegroundColor Cyan

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)

try {
    $listener.Start()
    Write-Host "Servidor ativo com sucesso! Abrindo navegador..." -ForegroundColor Green
    Start-Process $url
} catch {
    Write-Host "Erro ao iniciar o servidor na porta $port: $_" -ForegroundColor Red
    Write-Host "Tentando abrir o arquivo index.html diretamente..." -ForegroundColor Yellow
    Start-Process "$workspacePath\index.html"
    exit
}

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $localPath = $request.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrWhiteSpace($localPath) -or $localPath -eq '/') {
            $localPath = "index.html"
        }

        $filePath = Join-Path $workspacePath $localPath

        if (Test-Path $filePath -PathType Leaf) {
            $content = [System.IO.File]::ReadAllBytes($filePath)
            
            # Definir Content-Type
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            switch ($extension) {
                ".html" { $response.ContentType = "text/html; charset=utf-8" }
                ".css"  { $response.ContentType = "text/css; charset=utf-8" }
                ".js"   { $response.ContentType = "application/javascript; charset=utf-8" }
                ".json" { $response.ContentType = "application/json; charset=utf-8" }
                ".png"  { $response.ContentType = "image/png" }
                ".jpg"  { $response.ContentType = "image/jpeg" }
                ".svg"  { $response.ContentType = "image/svg+xml" }
                Default { $response.ContentType = "application/octet-stream" }
            }

            $response.ContentLength64 = $content.Length
            $response.OutputStream.Write($content, 0, $content.Length)
            $response.StatusCode = 200
        } else {
            $notFound = [System.Text.Encoding]::UTF8.GetBytes("<h1>404 - Arquivo não encontrado</h1>")
            $response.StatusCode = 404
            $response.ContentType = "text/html; charset=utf-8"
            $response.ContentLength64 = $notFound.Length
            $response.OutputStream.Write($notFound, 0, $notFound.Length)
        }
        $response.Close()
    } catch {
        # Conexão encerrada pelo cliente ou servidor
    }
}
