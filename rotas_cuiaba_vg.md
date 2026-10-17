# 🗺️ Guia de Rotas Logísticas Metropolitanas: Cuiabá e Várzea Grande (MT)
## Roteirização Viável para Motoboys, Endereços Reais e Conexões Intermunicipais

---

## 1. 🌉 Geografia Logística da Região Metropolitana

A operação de entregas na Grande Cuiabá é marcada pela conurbação entre **Cuiabá** e **Várzea Grande**, divididas naturalmente pelo **Rio Cuiabá**. Para uma operação de entregas rápida e viável para motocicletas, o planejamento das travessias pelas pontes é o fator crítico para evitar congestionamentos nos horários de pico (11h30-13h30 e 17h00-19h00).

```
                      [ CUIABÁ - ZONA NORTE / CPA ]
                             | (Av. do CPA)
                      [ CENTRO HISTÓRICO ]
                       /        |        \
    (Av. Miguel Sutil)/         |         \(Av. Fernando Corrêa)
                     v          v          v
              [ GOIABEIRAS ]  [ PORTO ]  [ JARDIM DAS AMÉRICAS / UFMT ]
                     \          |          /
======================\=========|=========/============================
                        RIO CUIABÁ (Pontes)
   [Ponte Mário Andreazza] [Ponte Nova/FEB] [Ponte Sérgio Motta]
======================/=========|=========\============================
                     v          v          v
              [ JD. GLÓRIA ]  [ CENTRO VG ] [ CRISTO REI / AEROPORTO ]
                    \           |          /
                     [ VÁRZEA GRANDE - ZONA SUL ]
```

---

## 2. 🕸️ Matriz de Conexão Entre Bairros (Grafo Viário da Grande Cuiabá)

O sistema organiza a roteirização conectando cada bairro aos seus vizinhos diretos, permitindo montar corredores de entrega fluidos:

### 🟢 Bairros de Cuiabá e suas Ligações Diretas:

| Bairro de Origem | Bairros Conectados Diretamente | Principal Via de Conexão | Distância Média |
|---|---|---|---|
| **Dom Aquino (Hub)** | ➔ **Porto**<br>➔ **Jardim das Américas**<br>➔ **Ponte Nova (VG)**<br>➔ **Cristo Rei (VG)** | Av. Beira Rio<br>Av. Fernando Corrêa<br>Ponte Nova (Av. da FEB)<br>Ponte Sérgio Motta | 2.1 km<br>3.8 km<br>3.4 km<br>3.9 km |
| **Porto** | ➔ **Dom Aquino**<br>➔ **Centro Norte**<br>➔ **Goiabeiras**<br>➔ **Centro de VG** | Av. Beira Rio<br>Av. Prainha / Generoso Ponce<br>Av. Senador Metello<br>Ponte Júlio Müller | 2.1 km<br>2.2 km<br>2.8 km<br>3.5 km |
| **Centro Norte / Histórico** | ➔ **Porto**<br>➔ **Goiabeiras**<br>➔ **Bosque da Saúde (CPA)**<br>➔ **Dom Aquino** | Av. Prainha<br>Av. Getúlio Vargas / Isaac Póvoas<br>Av. Historiador Rubens de Mendonça<br>Av. Cel. Escolástico | 2.2 km<br>2.5 km<br>3.2 km<br>2.7 km |
| **Goiabeiras / Santa Rosa** | ➔ **Centro Norte**<br>➔ **Porto**<br>➔ **Bosque da Saúde**<br>➔ **Jd. Glória (VG)** | Av. Getúlio Vargas<br>Av. Senador Metello<br>Av. Miguel Sutil (Perimetral)<br>Ponte Mário Andreazza | 2.5 km<br>2.8 km<br>3.6 km<br>6.5 km |
| **Bosque da Saúde** | ➔ **Centro Norte**<br>➔ **Goiabeiras**<br>➔ **Morada da Serra (CPA II)**<br>➔ **Jardim das Américas** | Av. do CPA<br>Av. Miguel Sutil<br>Av. do CPA Norte<br>Av. Miguel Sutil Sul | 3.2 km<br>3.6 km<br>4.2 km<br>4.9 km |
| **Morada da Serra / CPA II** | ➔ **Bosque da Saúde**<br>➔ **CPA I e CPA IV**<br>➔ **Três Barras** | Av. Hist. Rubens de Mendonça<br>Av. Brasil<br>Av. Alice Freire | 4.2 km<br>1.5 km<br>2.8 km |
| **Jardim das Américas** | ➔ **Dom Aquino**<br>➔ **Bosque da Saúde**<br>➔ **Coxipó / Tijucal**<br>➔ **Cristo Rei (VG)** | Av. Fernando Corrêa<br>Av. Miguel Sutil<br>Av. Fernando Corrêa Sul<br>Ponte Sérgio Motta | 3.8 km<br>4.9 km<br>4.5 km<br>4.1 km |

---

### 🔵 Bairros de Várzea Grande e suas Ligações Diretas:

| Bairro de Origem | Bairros Conectados Diretamente | Principal Via de Conexão | Distância Média |
|---|---|---|---|
| **Ponte Nova (Av. da FEB)** | ➔ **Dom Aquino (Cuiabá)**<br>➔ **Porto (Cuiabá)**<br>➔ **Centro de VG**<br>➔ **Ipase / Aeroporto**<br>➔ **Cristo Rei** | Ponte Nova<br>Alameda Júlio Müller<br>Av. da FEB<br>Av. Gov. João Ponce de Arruda<br>Av. Dr. Paraná | 3.4 km<br>3.1 km<br>2.4 km<br>1.8 km<br>2.9 km |
| **Centro de VG (Couto Magalhães)** | ➔ **Ponte Nova**<br>➔ **Porto (Cuiabá)**<br>➔ **Ipase**<br>➔ **Jardim Glória** | Av. Couto Magalhães / FEB<br>Ponte Júlio Müller<br>Av. Filinto Müller<br>Av. Júlio Campos | 2.4 km<br>3.5 km<br>2.2 km<br>3.6 km |
| **Cristo Rei** | ➔ **Ponte Nova**<br>➔ **Dom Aquino (Cuiabá)**<br>➔ **Jd. das Américas (Cuiabá)**<br>➔ **Parque do Lago** | Av. Dr. Paraná<br>Ponte Sérgio Motta<br>Ponte Sérgio Motta ➔ Beira Rio<br>Av. 31 de Março | 2.9 km<br>3.9 km<br>4.1 km<br>2.5 km |
| **Jardim Glória / Costa Verde** | ➔ **Centro de VG**<br>➔ **Goiabeiras (Cuiabá)**<br>➔ **Ipase** | Av. Júlio Campos<br>Ponte Mário Andreazza<br>Av. Alzira Santana | 3.6 km<br>6.5 km<br>2.8 km |
| **Ipase / Aeroporto** | ➔ **Centro de VG**<br>➔ **Ponte Nova**<br>➔ **Jardim Glória** | Av. Filinto Müller<br>Av. João Ponce de Arruda<br>Av. Alzira Santana | 2.2 km<br>1.8 km<br>2.8 km |

---

## 3. 🛵 Corredores Logísticos Bairro a Bairro (Rotas Conectadas)

### Corredor 1: Cuiabá Eixo Norte (Sem Cruzar Pontes)
`Dom Aquino (Hub)` ➔ `Porto` ➔ `Centro Norte` ➔ `Bosque da Saúde` ➔ `Morada da Serra (CPA II)`
- **Tempo Total:** ~42 min | **Distância:** 14.5 km
- **Vantagem:** Evita o gargalo das pontes nos horários de pico (12h-13h30).

### Corredor 2: Travessia Metropolitana FEB (Cuiabá ⇄ Várzea Grande)
`Dom Aquino (Hub)` ➔ `Porto` ➔ `[Ponte Nova]` ➔ `Ponte Nova VG` ➔ `Centro de VG (Couto Magalhães)` ➔ `Ipase`
- **Tempo Total:** ~38 min | **Distância:** 13.8 km
- **Vantagem:** Conecta os principais polos atacadistas e comerciais das duas cidades.

### Corredor 3: Anel Sul Metropolitano (Cristo Rei & 3 Américas)
`Dom Aquino (Hub)` ➔ `[Ponte Sérgio Motta]` ➔ `Cristo Rei (VG)` ➔ `Ponte Nova VG` ➔ `[Ponte Nova]` ➔ `Jardim das Américas (Cuiabá)`
- **Tempo Total:** ~40 min | **Distância:** 15.2 km
- **Vantagem:** Tráfego rápido em vias duplicadas e acesso prioritário à UFMT.
