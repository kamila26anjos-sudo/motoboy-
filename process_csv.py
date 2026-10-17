import csv, json, re, os

workdir = r'C:\Users\admin\Documents\monitormentoboy'

# Processar Cuiabá CSV
cuiaba_ruas = []
with open(os.path.join(workdir, 'cuiaba_denominacoes_logradouros.csv'), encoding='utf-8') as f:
    reader = csv.reader(f)
    header = next(reader)
    for row in reader:
        if len(row) >= 6:
            denom = row[0].strip().strip('"')
            bairro = row[5].strip().strip('"')
            if denom and bairro and denom not in ['Denominação Atual']:
                cuiaba_ruas.append((denom, bairro))

# Processar VG CSV
vg_ruas = []
with open(os.path.join(workdir, 'varzea_grande_anexo1_completo.csv'), encoding='utf-8') as f:
    reader = csv.reader(f)
    header = next(reader)
    for row in reader:
        if len(row) >= 6:
            regiao = row[0].strip().strip('"')
            loteamento = row[1].strip().strip('"')
            proposta = row[5].strip().strip('"') if len(row) > 5 else ''
            if proposta and regiao:
                bairro_match = re.search(r'Bairro:\s*([^,]+)', regiao)
                bairro = bairro_match.group(1).strip() if bairro_match else regiao
                vg_ruas.append((proposta, bairro, loteamento))

print('=== CUIABA RUAS ===')
for r in cuiaba_ruas:
    print(r)
print()
print('=== VG RUAS ===')
for r in vg_ruas:
    print(r)
print()
print('Total Cuiaba:', len(cuiaba_ruas), 'Total VG:', len(vg_ruas))

# Agrupar por bairro
from collections import defaultdict
cuiaba_by_bairro = defaultdict(list)
for rua, bairro in cuiaba_ruas:
    cuiaba_by_bairro[bairro].append(rua)

vg_by_bairro = defaultdict(list)
for rua, bairro, loteamento in vg_ruas:
    vg_by_bairro[bairro].append(rua)

print()
print('=== CUIABA POR BAIRRO ===')
for b, ruas in sorted(cuiaba_by_bairro.items()):
    print(f'{b}: {len(ruas)} ruas -> {ruas[:5]}')

print()
print('=== VG POR BAIRRO ===')
for b, ruas in sorted(vg_by_bairro.items()):
    print(f'{b}: {len(ruas)} ruas -> {ruas[:5]}')
