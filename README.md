# luan-study-os — FME Iezzi PDF Viewer

Viewer de PDFs do FME Iezzi hospedado no GitHub Pages.
Integrado com a Study OS para abrir qualquer seção na página exata.

## Estrutura
```
luan-study-os/
├── pdfs/              ← PDFs dos 7 volumes (gerados pelo script)
├── viewer/
│   └── index.html     ← Viewer PDF.js
├── scripts/
│   └── prepare_pdfs.py
├── manifest.json      ← Gerado automaticamente
└── deploy.sh
```

## Como usar o viewer
```
https://SEU_USUARIO.github.io/luan-study-os/viewer/?file=pdfs/fme_vol_1.pdf&page=40&title=Conjuntos%20Num%C3%A9ricos
```

Parâmetros:
- `file` — caminho do PDF relativo à raiz
- `page` — número da página (abre diretamente)
- `title` — nome da seção (aparece na toolbar)
