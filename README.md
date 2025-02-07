GitHub-Viewer

Uma aplicação IOS (UIKit) que consome uma API que realiza buscas por repositórios e informações de usuarios do GitHub através do nome de usuário, o retorno pode ser vizualizado na view de detalhes contendo o nome do usuário, sua foto de perfil (caso exista), seus repositórios e suas respectivas linguagens.

📌 Padrão de Commits 
• feat: Adição de um novo recurso 
• fix: Correção de bugs 
• refactor: Melhorias no código sem mudar comportamento 
• test: Adição/modificação de testes • docs: Alterações na documentação 
• chore: Atualizações que não afetam código diretamente (ex: gitignore) 
• style: Ajustes de formatação (espaços, lint, etc)

📌 Tecnologias Utilizadas
- Swift (UIKit)
- URLSession (para requisição da API)
- Auto Layout programático
- MVVM Architecture Pattern
- Singletoon Pattern
- Testes unitários

📂 Estrutura do Projeto
📂 Models # Estruturas de dados
📂 Views # Interfaces gráficas
📂 ViewModels # Lógica de exibição (se MVVM)
📂 Services # Chamadas à API
📂 Tests # Testes unitários
📄 README.md # Documentação
📄 .gitignore # Arquivos ignorados pelo Git

📌 Funcionalidades
- Busca de usuário por nome
- Exibição de detalhes do usuário (foto e informações)
- Interface programática com Auto Layout
- Testes unitários
