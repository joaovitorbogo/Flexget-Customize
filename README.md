# Flexget Config Editor

Este é um editor com interface gráfica (GUI) para Windows, desenvolvido em Delphi, para criar e gerenciar o arquivo de configuração `config.yml` do **FlexGet**.

O objetivo principal desta ferramenta é simplificar a criação e edição de tarefas, templates e agendamentos, especialmente para usuários que não estão familiarizados com a sintaxe YAML. O editor fornece uma interface visual para gerenciar configurações complexas de forma intuitiva.



## Índice

1.  [Conceitos: O que é e Como o FlexGet Funciona?](#conceitos-o-que-é-e-como-o-flexget-funciona)
2.  [Pré-requisitos de Instalação](#pré-requisitos-de-instalação)
3.  [Passo a Passo: Instalação e Configuração](#passo-a-passo-instalação-e-configuração)
    *   [Passo 1: Instalar o Python](#passo-1-instalar-o-python)
    *   [Passo 2: Instalar o FlexGet](#passo-2-instalar-o-flexget)
    *   [Passo 3: Instalar e Configurar o qBittorrent](#passo-3-instalar-e-configurar-o-qbittorrent)
4.  [Como Usar o Flexget Config Editor](#como-usar-o-flexget-config-editor)
5.  [Executando o FlexGet](#executando-o-flexget)

---

## Conceitos: O que é e Como o FlexGet Funciona?

**FlexGet** é uma poderosa ferramenta de automação multifuncional para conteúdo digital. Ele pode monitorar feeds RSS, sites de torrents, e outras fontes para descobrir novos conteúdos e, em seguida, passá-los para outros programas, como um cliente de torrent (qBittorrent) para download.

Seu funcionamento é baseado em 3 pilares principais:

1.  **Arquivo de Configuração (`config.yml`):** Este é o cérebro do FlexGet. É um arquivo de texto no formato YAML onde você define tudo o que o FlexGet deve fazer. É este arquivo que nosso editor gerencia.

2.  **Tarefas (Tasks):** Uma tarefa é um conjunto de instruções para uma finalidade específica. Por exemplo, você pode ter uma tarefa chamada `download_animes` e outra chamada `download_series`. Cada tarefa executa uma série de plugins em sequência.

3.  **Plugins:** São os blocos de construção do FlexGet. Cada plugin tem uma função específica. Os mais comuns que usamos neste projeto são:
    *   `rss`: Monitora um feed RSS para novas entradas.
    *   `template`: Permite definir um conjunto de configurações (como filtros de qualidade) e reutilizá-lo em várias tarefas.
    *   `qbittorrent`: Envia os arquivos `.torrent` ou links magnéticos para o qBittorrent fazer o download.
    *   `schedule`: Permite que o FlexGet execute tarefas automaticamente em intervalos de tempo definidos.

Nosso editor manipula esses conceitos para gerar um arquivo `config.yml` válido que o FlexGet pode executar.

---

## Pré-requisitos de Instalação

Antes de usar o editor e o FlexGet, você precisa ter o seguinte software instalado em seu sistema Windows:

*   **Python** (versão 3.6 ou superior)
*   **FlexGet** (instalado via `pip`, o gerenciador de pacotes do Python)
*   **qBittorrent** (com a Interface Web habilitada)

---

## Passo a Passo: Instalação e Configuração

### Passo 1: Instalar o Python

1.  **Baixe o Python:** Vá para o site oficial [python.org](https://www.python.org/downloads/windows/) e baixe o instalador mais recente para Windows.
2.  **Execute o Instalador:**
    *   Na primeira tela do instalador, marque a caixa **"Add Python to PATH"**. **Este passo é extremamente importante!**
    *   Clique em "Install Now" e siga as instruções.
    ![Adicionar Python ao PATH](https://docs.python.org/3/_images/win_installer.png)
3.  **Verifique a Instalação:**
    *   Abra o **Prompt de Comando** (pesquise por `cmd` no menu Iniciar).
    *   Digite o comando `python --version` e pressione Enter. Você deve ver a versão do Python que acabou de instalar.

### Passo 2: Instalar o FlexGet

1.  **Abra o Prompt de Comando.**
2.  **Instale o FlexGet:** Digite o seguinte comando e pressione Enter:
    ```bash
    pip install flexget
    ```
3.  **Verifique a Instalação:** Digite `flexget --version`. Você deve ver a versão do FlexGet.

O FlexGet agora está instalado. Ele irá procurar seu arquivo de configuração na pasta `%APPDATA%\flexget` (ex: `C:\Users\SeuUsuario\AppData\Roaming\flexget\config.yml`).

### Passo 3: Instalar e Configurar o qBittorrent

1.  **Baixe e Instale o qBittorrent:** Vá para o site oficial [qbittorrent.org](https://www.qbittorrent.org/download.php) e instale a versão mais recente para Windows.

2.  **Habilite a Interface de Usuário Web (Web UI):** O FlexGet se comunica com o qBittorrent através da Web UI. Para habilitá-la:
    *   Abra o qBittorrent.
    *   Vá para o menu **Ferramentas (Tools) -> Opções (Options)...**
    *   Na janela de Opções, clique na aba **Interface Web (Web UI)**.
    *   Marque a caixa **"Interface de Usuário Web (Controle remoto)"**.
    *   Em **"Endereço IP"**, mantenha `localhost`.
    *   Em **"Porta"**, use `8080` (ou outra porta, se preferir, mas lembre-se de usá-la no editor).
    *   Em **"Autenticação"**, defina um **Nome de usuário** e uma **Senha**. Para começar, você pode usar `admin` e `adminadmin`, como no nosso exemplo, mas é **altamente recomendável** que você use uma senha mais segura.
    *   **Importante:** Desmarque a opção "Ativar proteção contra CSRF (Cross-Site Request Forgery)". O FlexGet pode ter problemas com essa proteção ativada.
    *   Clique em "Aplicar" e "OK".

---

## Como Usar o Flexget Config Editor

Com todos os pré-requisitos instalados, você pode usar nosso editor:

1.  **Novo Arquivo:**
    *   Clique em **"Novo Arquivo"** para criar uma configuração do zero.
    *   Isso irá pré-popular o editor com a estrutura padrão (templates, schedules), mas sem nenhuma tarefa, pronto para você começar a adicionar.

2.  **Carregar Arquivo:**
    *   Clique em **"Carregar YAML"** para abrir um arquivo `config.yml` existente.
    *   Navegue até `%APPDATA%\flexget` e selecione seu `config.yml`.

3.  **Editando a Configuração:**
    *   **Configurações Globais (Replicar):** Esta seção é um facilitador da UI. Os valores que você define aqui (como host, porta, senha do qBittorrent e templates padrão) serão aplicados a **todas as suas tarefas** quando você clicar em "Salvar". Isso economiza tempo e evita erros.
    *   **Templates:** Você pode editar os filtros e configurações dos seus templates.
    *   **Tasks:**
        *   **Adicionar:** Clique em **"Adicionar Task"**, dê um nome único e a nova task será criada usando as configurações globais como base.
        *   **Renomear:** Dê um clique lento ou pressione `F2` sobre o nome de uma task na árvore para renomeá-la.
        *   **Remover:** Selecione uma task e clique em **"Remover Task Selecionada"**.
        *   **Editar:** Ao selecionar uma task, você pode editar suas propriedades individuais:
            *   **RSS URL:** O link do feed específico para esta task.
            *   **Qbit Path:** A pasta de destino para os downloads desta task. Clique no botão **"..."** para selecionar uma pasta facilmente.

4.  **Salvando:**
    *   Clique em **"Salvar"**. Se for um arquivo novo, ele pedirá um local para salvar (agirando como "Salvar Como..."). Se for um arquivo já existente, ele o sobrescreverá com as novas alterações.
    *   É neste momento que as "Configurações Globais" são replicadas para todas as tasks antes de o arquivo ser escrito.

---

## Executando o FlexGet

Depois de salvar seu `config.yml` com o editor:

1.  **Abra o Prompt de Comando.**
2.  **Navegue até a pasta de configuração (opcional, mas recomendado):**
    ```bash
    cd %APPDATA%\flexget
    ```
3.  **Execute o FlexGet:**
    ```bash
    flexget execute
    ```
    Este comando irá executar todas as tarefas definidas no seu `config.yml`. O FlexGet irá checar os feeds RSS, filtrar as entradas e, se encontrar algo novo, enviará para o qBittorrent.

4.  **Para testar uma única task:**
    ```bash
    flexget execute --tasks NOME_DA_SUA_TASK
    ```

Para automação completa, você pode usar o **Agendador de Tarefas do Windows** para executar o comando `flexget execute` a cada X minutos ou horas.
