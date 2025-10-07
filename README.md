# 🚀 Firebase Auth & Firestore Profile Management (Flutter)

Este repositório contém um aplicativo Flutter completo que demonstra a implementação robusta de **Autenticação de Usuário (Registro e Login)** utilizando **Firebase Authentication** e o gerenciamento seguro de **Perfis de Usuário** usando **Cloud Firestore**.

O foco principal deste projeto é aplicar as **Melhores Práticas de Segurança** do Firebase, garantindo que cada usuário só possa criar, ler, atualizar e deletar os **seus próprios dados de perfil**.

## ✨ Funcionalidades

  * **Registro de Usuário:** Criação de conta utilizando E-mail e Senha (Firebase Auth).
  * **Login e Logout:** Gerenciamento de sessão de usuário.
  * **Armazenamento Seguro de Dados:** Após o cadastro, o perfil completo do usuário (Nome, Sobrenome, Idade) é salvo no Cloud Firestore.
  * **Visualização Estilizada de Perfil:** Exibição dos dados do usuário logado na `HomePage` utilizando um `FutureBuilder` e um layout moderno.
  * **Controle Assíncrono:** Uso correto de `async/await` e verificação de `if (mounted)` para garantir estabilidade e evitar erros de estado durante a navegação.

## 🔒 Modelo de Segurança do Firestore

A segurança é garantida por regras estritas que vinculam o acesso aos dados do perfil ao UID (User ID) do usuário logado.

### Regras Aplicadas (`firestore.rules`)

As seguintes regras garantem que consultas amplas (como `collection('usuarios').get()`) sejam negadas e que apenas o proprietário do documento possa manipulá-lo:

```firestore-security-rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /usuarios/{userId} {
      // Permite CRUD (Create, Read, Update, Delete) apenas se o ID do documento
      // for igual ao UID do usuário logado.
      allow read, create, update, delete: if request.auth != null && request.auth.uid == userId;
    }
    
    match /{document=**} {
      allow read, write: if false; // Nega acesso a outras coleções por padrão
    }
  }
}
```

## 🛠️ Pré-requisitos

Antes de executar este projeto, você precisará:

1.  Ter o **Flutter SDK** instalado.
2.  Ter uma conta no **Firebase** e um novo projeto criado.
3.  Configurar seu projeto Flutter para usar o Firebase (adicionar `google-services.json` ou `GoogleService-Info.plist`).

## ⚙️ Configuração do Projeto

Siga estes passos para configurar o ambiente de desenvolvimento:

### 1\. Clonar o Repositório

```bash
git clone https://github.com/adrielhenry33/firebase-auth-practice.git
cd firebase-auth-practice
```

### 2\. Instalar Dependências

Certifique-se de que as dependências do Firebase e do Google Fonts estejam instaladas:

```bash
flutter pub get
```

### 3\. Habilitar Serviços do Firebase

No seu Console do Firebase:

1.  Vá em **Authentication** e habilite o método de login **Email/Senha**.
2.  Vá em **Firestore Database**, crie o banco de dados e publique as **Regras de Segurança** mencionadas acima.

### 4\. Executar o Aplicativo

Execute o projeto em um emulador ou dispositivo conectado:

```bash
flutter run
```

O aplicativo iniciará na tela de login/registro. Use a opção de cadastro para criar um novo usuário e testar o salvamento e a exibição do perfil.

## 🤝 Contribuições

Sinta-se à vontade para abrir *issues* ou *pull requests* para melhorias, correções de bugs ou adições de funcionalidades.
