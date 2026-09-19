# Plano — `garden` como hub de jardinagem digital

> Documento de trabalho. A versão publicada e permanente do método vive em
> `content/about/method.md`.

## 0. Diagnóstico do estado inicial

Quartz v5 (branch `v5`), site `notes.thisdev.space`, conteúdo num **submódulo git**
`content/` → `js-bruno/garden-notes` (vault Obsidian).

- 46 notas markdown, **1** com frontmatter (`index.md`)
- **4** wikilinks no vault inteiro, **2** tags (`#habbo`, `#selfhost`)
- ~35 stubs de 0–6 linhas em `internet-finds/sites/`
- 7 notas completamente vazias
- Grafo = 46 pontos isolados. É um fichário, não um jardim.

### Bugs reais encontrados

| Problema | Evidência |
|---|---|
| Links quebrados | `cool web tools/astral_python.md:3-4` → `[ruff](ruff.md)`, `[uv](uv.md)`, mas os arquivos estão em `sites/` |
| Nota duplicada | `cool web tools/astral_python.md` ≈ `sites/Astral Tooling(python).md` |
| Binário no vault | `content/internet-finds/a.out` |
| Notas vazias | `artvee`(só URL), `Commit Goods`, `drunk anime blog`, `home-manager`, `nix`, `Sem título`, `uv` |
| Wikilinks pendurados | `[[shrine]]`, `[[ditcher]]`, `[[thisdev.space]]` |
| `makefile` quebrado | `git git clone --recurse-submodules …` |

---

## 1. O método de ensino

Combinação de três métodos estabelecidos, mais camadas de suporte.

### A. Feynman Technique — motor de cada nota

Richard Feynman; popularizado por Scott Young em *Ultralearning*.

1. **Explique como se ensinasse** alguém que não sabe nada — sem jargão
2. **Onde você travou = seu gap real de conhecimento.** Volte à fonte
3. **Simplifique e crie uma analogia.** Sem analogia → ainda não entendeu
4. **Refine ensinando de verdade** (em voz alta, ou publicando)

O passo 2 é o que faz disto um *método de ensino* e não só tomada de notas.
Jargão é o esconderijo da ignorância.

### B. Knowledge Flow do jzhao — formato do vault

De *Networked Thought* (referenciado no README deste repo e na home do Quartz):

- **Seeds** — captura de fricção zero, bookmark, pensamento cru
- **Saplings** — nós únicos de pensamento, sem silo por categoria
- **Fruits** — trabalho derivado: ensaios longos, projetos, coisas maduras o
  bastante pra compartilhar

Vocabulário nativo do Quartz. O jardim se explica sozinho.

### C. Learn In Public (swyx) — a prática

- **"Learning exhaust"** — crie o hábito de excretar aprendizado. Escreva pra
  você de 3 meses atrás, não pra audiência
- **"Make the thing you wish you had found"**
- **"Talk while you code"** — build logs escritos *como ensino*
- **"Try your best to be right, but don't worry when you're wrong"**

### D. Camadas de suporte

- **Bloom's Taxonomy** (1956; rev. Anderson & Krathwohl 2001) —
  *Remember → Understand → Apply → Analyze → Evaluate → Create*.
  Uso como **diagnóstico**: o vault inicial era ~95% `Remember`.
- **Protégé Effect** (Chase, Chin, Oppezzo & Schwartz 2009) — ensinar um agente
  melhora mais o aprendizado do que estudar. Base empírica pra escrever sempre
  em modo professor.
- **Active recall / spaced retrieval** (Ebbinghaus; Roediger & Karpicke 2006) —
  re-explicar de memória antes de reler. Ritual semanal em `logs/`.
- **Gibbs' Reflective Cycle** (1988) — os 5 passos de `Aprender em Público.md`
  são uma versão comprimida disso. Formalizado como template.

> **Zettelkasten**: aproveita-se só *atomicidade* (1 conceito por nota) +
> *palavras próprias* + *links densos*. Rejeita-se o sistema formal completo —
> jzhao: *"there is way too much upfront friction that by the time I've thought
> about how to organize my thought into folders categories, I've lost it."*

---

## 2. Estrutura de diretórios

**Decisão de design: pastas = estágio no pipeline, NÃO tópico.**

Tópico em pasta cria silo e mata conexão cruzada. Estágio em pasta não — e ainda
diz o quão cozida está a ideia. Tópico vem de **tags + wikilinks + MOCs**.

```
content/
├── index.md              # O HUB — MOC dos MOCs, porta de entrada
├── seeds/                # 🌱 captura. fricção ~zero. 1-3 linhas OK
├── saplings/             # 🌿 1 conceito por nota, passagem Feynman 1-3
├── fruits/               # 🌳 acabado, ensinável, publicável
├── projects/             # build logs com começo/meio/fim
├── logs/                 # learning logs / TIL / revisão semanal
├── internet-finds/       # catálogo do externo (mantido)
│   ├── sites/
│   ├── cool web tools/
│   └── cool_articles/
└── about/                # o próprio jardim: método, convenções, templates
```

**Mover arquivo não quebra URL:** `alias-redirects` está ativo
(`quartz.config.yaml:134`) e o Quartz suporta `permalink` no frontmatter —
*"A custom URL for the page that will remain constant even if the path to the
file changes"* (`docs/getting-started/authoring-content.md:34`).

---

## 3. O hub (`index.md`)

O `index.md` original misturava manifesto + WIP + TODO + diário. Separação:

| Conteúdo original | Destino |
|---|---|
| Manifesto ("subi esse dominio com quartz…") | `index.md`, enxugado |
| `## WIP:` (4 itens) | `logs/now.md` |
| `# TODO de coisas pra fazer…` (6 itens) | seeds em `seeds/` |
| `[[shrine]]`, `[[ditcher]]`, `[[thisdev.space]]` | seeds explícitas |

Nenhuma palavra do autor é apagada — só relocada.

---

## 4. Contrato de intake

Todo output recebido passa por:

1. **Classificar** → seed / sapling / fruit / project log / internet-find
2. **Nomear** → inglês, kebab-case, substantivo ou verbo, o mais simples
   possível (jzhao: *"Name notes to be as simple as possible"*)
3. **Frontmatter mínimo** → `title`, `tags`, `description`, `aliases`.
   Nada de metadata de estágio. Bate com `note-properties`
   (`quartz.config.yaml:248-252`)
4. **Linkar por conceito, não por match exato** → mínimo 2 `[[wikilinks]]` de
   saída + linha `See also:` quando fizer sentido
5. **Preservar a voz do autor** → texto pt-BR continua pt-BR
6. **Nunca deletar palavras** → só reestruturar e expandir
7. **Sinalizar gaps** → `> [!question] gap` onde há jargão sem explicação ou
   afirmação sem fonte. Nunca preencher o gap pelo autor
8. **Reportar** → arquivo criado, links adicionados, backlinks afetados, gaps

---

## 5. internet-finds — grafo e tags

Fase pedida explicitamente depois da estrutura:

1. ~~Visitar cada URL~~ — **não feito**, a pedido do autor ("nao precisa fazer
   isso nas urls"). Backlinks e tags foram construídos a partir do conteúdo que
   já existia nas notas, sem consultar as páginas.
2. **Preencher as notas vazias** com o mínimo descritivo — sem inventar opinião
   do autor
3. **Criar wikilinks cruzados** entre notas que compartilham assunto, autor,
   estética ou tecnologia → o grafo deixa de ser 46 pontos isolados
4. **Criar taxonomia de tags** e aplicar em todas as notas
5. **Criar MOCs por tag** em `internet-finds/`

Regra: link por **conceito**, não por coincidência de string.

### Taxonomia de tags aplicada

- **Tipo**: `find/site`, `find/tool`, `find/article`, `find/community`,
  `find/art`, `find/music`
- **Tema**: `design`, `nix`, `python`, `rust`, `anime`, `music`, `indieweb`,
  `selfhost`, `webdev`, `linux`, `vim`, `gaming`, `digital-garden`, `learning`
- **Estágio** (fora do `internet-finds`): `seed`, `sapling`, `fruit`, `project`,
  `log`, `meta`

---

## 6. Fora de escopo

`quartz.config.yaml` **não é tocado** (decisão do autor: manter `locale: en-US`).

Registrado para decisão futura:

- `recent-notes` e `tag-list` seguem `enabled: false` → MOCs são listas manuais
- `footer` (`quartz.config.yaml:227-229`) aponta pra `github.com/jackyzha0/quartz`
  e o Discord do Quartz, não pros links do autor

---

## 7. Ordem de execução

- [x] 1. Escrever este plano
- [x] 2. Criar `seeds/ saplings/ fruits/ projects/ logs/ about/`
- [x] 3. Migrar as 3 notas da raiz
- [x] 4. Converter WIP/TODO em seeds
- [x] 5. Reescrever `index.md` como hub
- [x] 6. `about/method.md` + templates Feynman/Gibbs
- [x] 7. Consertar links quebrados, duplicata, `a.out`, `Sem título.md`, `makefile`
- [x] 8. Backlinks do `internet-finds` (sem consultar URLs, a pedido do autor)
- [x] 9. Criar tags e organizar achados por tag
- [x] 10. Verificar com `npx quartz build` — 0 links quebrados

## Resultado final

- **63** notas markdown (eram 46)
- **406** wikilinks (eram 4); **63** notas com link de saída
- **35** páginas de tag (eram 2 tags)
- **0** links internos quebrados (verificado no build emitido)
