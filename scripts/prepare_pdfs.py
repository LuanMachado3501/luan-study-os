"""
prepare_pdfs.py
Copia os PDFs dos volumes FME Iezzi para a pasta correta
e gera o manifest.json com metadados de cada volume.

USO:
    python3 prepare_pdfs.py --src /caminho/para/seus/pdfs

Espera arquivos nomeados:
    FME_VOL_1.pdf, FME_VOL_2.pdf, ... FME_VOL_7.pdf
    (qualquer variação com VOL1, Vol1, vol_1 também funciona)
"""

import os
import sys
import re
import shutil
import json
import argparse

VOLUMES = [
    {"vol": 1, "tema": "Conjuntos & Funções"},
    {"vol": 2, "tema": "Logaritmos"},
    {"vol": 3, "tema": "Trigonometria"},
    {"vol": 4, "tema": "Sequências, Matrizes, Determinantes e Sistemas"},
    {"vol": 5, "tema": "Combinatória & Probabilidade"},
    {"vol": 6, "tema": "Complexos, Polinômios & Equações"},
    {"vol": 7, "tema": "Geometria Analítica"},
]

def find_pdf(src_dir, vol_num):
    """Tenta encontrar o PDF do volume pelo número."""
    for fname in os.listdir(src_dir):
        if not fname.lower().endswith('.pdf'):
            continue
        nums = re.findall(r'\d+', fname)
        if nums and int(nums[0]) == vol_num:
            return os.path.join(src_dir, fname)
    return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--src', required=True, help='Pasta com os PDFs FME')
    args = parser.parse_args()

    src = os.path.expanduser(args.src)
    if not os.path.isdir(src):
        print(f'ERRO: pasta não encontrada: {src}')
        sys.exit(1)

    # Destino: pasta pdfs/ na raiz do projeto
    dest = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'pdfs')
    os.makedirs(dest, exist_ok=True)

    manifest = []
    for v in VOLUMES:
        pdf_path = find_pdf(src, v['vol'])
        if not pdf_path:
            print(f'⚠  Vol {v["vol"]} não encontrado em {src}')
            manifest.append({**v, "file": None})
            continue
        dest_name = f'fme_vol_{v["vol"]}.pdf'
        dest_path = os.path.join(dest, dest_name)
        shutil.copy2(pdf_path, dest_path)
        size_mb = os.path.getsize(dest_path) / 1024 / 1024
        print(f'✓  Vol {v["vol"]} — {dest_name} ({size_mb:.1f} MB)')
        manifest.append({**v, "file": f'pdfs/{dest_name}'})

    manifest_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'manifest.json')
    with open(manifest_path, 'w') as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)
    print(f'\n✓  manifest.json gerado em {manifest_path}')
    print('\nPróximo passo: rode deploy.sh')

if __name__ == '__main__':
    main()
