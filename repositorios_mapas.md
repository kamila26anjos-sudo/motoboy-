# 🗺️ Guia de Repositórios Gratuitos do GitHub para Mapas, Rotas e Geocodificação
## Soluções 100% Open-Source e Gratuitas para o MVP do MonitoramentoBoy

Este guia reúne as melhores tecnologias e repositórios do GitHub para substituir APIs pagas (como Google Maps ou Mapbox comercial), permitindo plotar endereços reais de **Cuiabá e Várzea Grande**, traçar rotas e geocodificar endereços sem custos de licença ou necessidade de cartão de crédito.

---

## 1. 🏆 Os Melhores Repositórios no GitHub

### 1.1. Visualização de Mapas (Rendering & Tiles)

| Repositório | GitHub | Descrição & Por Que Usar no MVP |
|---|---|---|
| **Leaflet** | [Leaflet/Leaflet](https://github.com/Leaflet/Leaflet) | **(Recomendado para o MVP)** Biblioteca JavaScript mais leve (~42 KB) e popular do mundo. Funciona em qualquer navegador sem dependências pesadas, compatível com OpenStreetMap e tiles escuros (CartoDB Dark). |
| **MapLibre GL JS** | [maplibre/maplibre-gl-js](https://github.com/maplibre/maplibre-gl-js) | Fork open-source do Mapbox GL v1. Utiliza WebGL para mapas vetoriais com rotação 3D, inclinação e animações fluidas. |
| **OpenFreeMap** | [hyperknot/openfreemap](https://github.com/hyperknot/openfreemap) | Provedor de tiles vetoriais gratuitos sem limites de visualização, sem necessidade de cadastro ou API key. |

---

### 1.2. Roteirização e Cálculo de Trajetos (Routing Engines)

| Repositório | GitHub | Descrição & Por Que Usar no MVP |
|---|---|---|
| **Leaflet Routing Machine** | [perliedman/leaflet-routing-machine](https://github.com/perliedman/leaflet-routing-machine) | **(Essencial)** Plugin para Leaflet que calcula e desenha a rota real sobre as ruas e pontes, fornecendo distância em km, tempo estimado e instruções curva a curva via OSRM. |
| **OSRM Backend** | [Project-OSRM/osrm-backend](https://github.com/Project-OSRM/osrm-backend) | Motor C++ de alto desempenho para cálculo do caminho mais curto na malha do OpenStreetMap. Pode ser consumido via servidor público gratuito (`router.project-osrm.org`) ou self-hosted via Docker. |
| **MapLibre Directions** | [maplibre/maplibre-gl-directions](https://github.com/maplibre/maplibre-gl-directions) | Plugin de rotas para MapLibre GL com suporte a waypoints interativos e OSRM. |

---

### 1.3. Geocodificação (Transformar Endereço de Rua em Latitude/Longitude)

| Repositório | GitHub | Descrição & Por Que Usar no MVP |
|---|---|---|
| **Leaflet Control Geocoder** | [perliedman/leaflet-control-geocoder](https://github.com/perliedman/leaflet-control-geocoder) | Adiciona uma barra de pesquisa ao mapa que busca endereços reais em Cuiabá/VG usando a API gratuita do **Nominatim**. |
| **Nominatim** | [osm-search/Nominatim](https://github.com/osm-search/Nominatim) | Servidor de busca e geocodificação oficial do OpenStreetMap. Permite busca reversa (lat/lng ➔ endereço) e busca direta. |
| **Photon** | [komoot/photon](https://github.com/komoot/photon) | Geocoder open-source de alta velocidade com autocompletar construído pela Komoot usando Elasticsearch e dados do OSM. |

---

## 2. 🧩 Arquitetura Gratuita Recomendada para o MVP

```
+-----------------------------------------------------------------------------------+
|                        FRONTEND WEB (MonitoramentoBoy)                            |
+-----------------------------------------------------------------------------------+
|                                                                                   |
|  [ Leaflet.js ] -----------------------------> Renderiza o mapa base              |
|        |                                       (CartoDB Dark / OpenStreetMap)     |
|        |                                                                          |
|        +---> [ Leaflet Control Geocoder ] ---> Busca endereços reais em Cuiabá/VG |
|        |                                       (via Nominatim OSM API)            |
|        |                                                                          |
|        +---> [ Leaflet Routing Machine ] ----> Traça rotas reais pelas pontes     |
|                                                (via OSRM Routing Engine API)      |
+-----------------------------------------------------------------------------------+
```

---

## 3. 💻 Exemplo de Código Pronto para Uso

Exemplo demonstrativo integrando **Leaflet + OpenStreetMap + Leaflet Routing Machine (OSRM)** centrado na Grande Cuiabá (Ponte Nova e Av. da FEB):

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Rotas Cuiabá & Várzea Grande - Leaflet + OSRM</title>
  
  <!-- Leaflet CSS -->
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <!-- Leaflet Routing Machine CSS -->
  <link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.css" />
  
  <style>
    #map { height: 100vh; width: 100%; }
  </style>
</head>
<body>

  <div id="map"></div>

  <!-- Leaflet JS -->
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <!-- Leaflet Routing Machine JS -->
  <script src="https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.js"></script>

  <script>
    // 1. Centraliza o mapa entre Cuiabá e Várzea Grande (próximo ao Rio Cuiabá)
    const map = L.map('map').setView([-15.6014, -56.0979], 13);

    // 2. Camada de mapa gratuita estilo escuro (CartoDB Dark Matter)
    L.tileLayer('https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png', {
      attribution: '&copy; OpenStreetMap &copy; CARTO',
      subdomains: 'abcd',
      maxZoom: 19
    }).addTo(map);

    // 3. Traçado de rota real via OSRM:
    // Ponto A: Hub Beira Rio (Cuiabá) -> [-15.6180, -56.0945]
    // Ponto B: Várzea Grande Shopping (Av. da FEB, VG) -> [-15.6525, -56.1218]
    L.Routing.control({
      waypoints: [
        L.latLng(-15.6180, -56.0945), // Hub Beira Rio
        L.latLng(-15.6525, -56.1218)  // VG Shopping (via Ponte Nova)
      ],
      router: L.Routing.osrmv1({
        serviceUrl: 'https://router.project-osrm.org/route/v1'
      }),
      routeWhileDragging: false,
      showAlternatives: true,
      lineOptions: {
        styles: [{ color: '#0ea5e9', weight: 5, opacity: 0.8 }]
      }
    }).addTo(map);
  </script>
</body>
</html>
```

---

## 4. 🚀 Vantagens Desta Stack para o MVP

1. **Custo Zero Real:** Sem limites surpresa de faturamento (como os US$ 200 do Google Cloud).
2. **Sem Cartão de Crédito:** Não exige vincular conta corporativa ou dados bancários para testar.
3. **Travessia de Ruas Reais:** O OSRM reconhece o sentido de mãos, viadutos e pontes da Grande Cuiabá (Ponte Nova, Sérgio Motta, Mário Andreazza e Júlio Müller).
4. **Resiliência:** Se a internet oscilar, pode-se usar o modo Canvas offline (já implementado no `index.html`) como fallback automático.
