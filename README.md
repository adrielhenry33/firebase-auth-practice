# Projeto Prático: Firebase Authentication & Firestore com Flutter

## 📝 Descrição

Este é um projeto Flutter simples criado para demonstrar e praticar a integração com os serviços do Firebase, especificamente **Firebase Authentication** para gerenciamento de usuários e **Cloud Firestore** para armazenamento de dados adicionais do usuário.

## ✨ Funcionalidades Implementadas

* **Autenticação de Usuários:**
    * **Cadastro:** Permite que novos usuários se registrem usando e-mail e senha. A senha deve ter no mínimo 6 caracteres.
    * **Login:** Permite que usuários existentes façam login com e-mail e senha.
    * **Redefinição de Senha:** Envia um e-mail para o usuário redefinir sua senha caso a esqueça.
    * **Gerenciamento de Sessão:** Mantém o usuário logado e redireciona automaticamente para a tela principal (`HomePage`) ou para a tela de autenticação (`AuthPage`) com base no estado de autenticação.
    * **Logout:** Permite que o usuário encerre sua sessão.
* **Firestore Database:**
    * **Adicionar Detalhes do Usuário:** Ao se registrar, informações adicionais (Nome, Sobrenome, Idade, Email) são salvas em uma coleção `usuarios` no Firestore, vinculadas ao UID do usuário. A data de criação também é registrada usando `FieldValue.serverTimestamp()`.
    * **Visualizar Detalhes do Usuário:** Na tela principal (`HomePage`), os detalhes do usuário logado (Nome, Sobrenome, Idade) são buscados e exibidos a partir do Firestore.
* **Gerenciamento da Conta:**
    * **Excluir Conta:** Permite que o usuário exclua sua própria conta. Requer reautenticação (confirmar e-mail e senha) por segurança antes de excluir os dados do Firestore e a conta de autenticação.

## 🛠️ Tecnologias Utilizadas

* **Flutter & Dart:** Framework e linguagem para construção da interface e lógica do app.
* **Firebase Authentication:** Para gerenciar o ciclo de vida da autenticação do usuário (cadastro, login, logout, redefinição de senha, exclusão).
* **Cloud Firestore:** Banco de dados NoSQL para armazenar e recuperar informações adicionais dos usuários.
* **Google Fonts:** Para estilização de texto.
* **Componentização:** Uso de um `TextFieldComponent` reutilizável para campos de entrada.

## 🏗️ Estrutura do Projeto (Simplificada)

* `lib/main.dart`: Ponto de entrada, inicialização do Firebase.
* `lib/firebase_options.dart`: Configurações específicas da plataforma para o Firebase.
* `lib/pages/`: Contém as diferentes telas (widgets `Scaffold`) da aplicação:
    * `auth_page.dart`: Controla a exibição entre Login e Registro.
    * `login_page.dart`: Tela de login.
    * `register_page.dart`: Tela de cadastro.
    * `home_page.dart`: Tela principal após o login.
    * `forgot_password_page.dart`: Tela para redefinição de senha.
    * `main_page.dart`: Verifica o estado de autenticação e direciona o usuário.
* `lib/components/`: Contém widgets reutilizáveis:
    * `text_field_component.dart`: Widget customizado para campos de texto.
