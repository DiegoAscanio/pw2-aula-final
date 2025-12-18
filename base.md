<meta charset="utf-8">

<style scoped>

body {
        font-family: Arial, sans-serif;
        margin: 2.5% 10% 0 10%;
        text-align: justify;
}

iframe {
    display: block;
    margin-left: auto;
    margin-right: auto;
    max-width: 100%;
}

img {
    display: block;
    margin-left: auto;
    margin-right: auto;
    width: 75%;
}

/* Figure / caption */
figure.youtube {
  margin: 1.5rem 0;
  text-align: center;
}

figure.youtube figcaption {
  margin-top: 0.6rem;
  font-size: 0.95rem;
  color: #333;
  line-height: 1.4;
}

/* título do vídeo */
figure.youtube .video-title {
  font-weight: 700;
  margin-bottom: 0.3rem;
}

/* metadados (canal, data) */
figure.youtube .meta {
  font-style: italic;
  font-size: 0.92rem;
  margin-bottom: 0.45rem;
}

/* citações */
figure.youtube .citation {
  font-family: Georgia, "Times New Roman", serif;
  font-size: 0.9rem;
  background: #fbfbfb;
  border-left: 3px solid #ddd;
  padding: 0.6rem 0.8rem;
  display: inline-block;
  text-align: left;
  max-width: 720px;
}

/* small helper for source link */
figure.youtube a.source {
  color: #0066cc;
  text-decoration: none;
}
figure.youtube a.source:hover { text-decoration: underline; }

pre { 
  position: relative;
}

.copy-btn {
  position: absolute; top: 8px; right: 8px;
  padding: 4px 8px; font-size: 12px; cursor: pointer;
}

</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/default.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/highlight.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/languages/java.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/languages/javascript.min.js"></script>

# Construção de Aplicações Web

## Camadas de Controle e Apresentação (_View_) / Divisão de Responsabilidades

Até então já discutimos inicialmente a arquitetura MVC (_Model-View-Controller_), já aprendemos a criar modelos (Models) para representar nossos dados e a representá-los em repositórios (na memória principal ou em bancos de dados) baseados nas operações CRUD (_Create, Read, Update, Delete_).

Agora, vamos:

1. Aprofundar o nosso entendimento sobre divisão de responsabilidades em aplicações web - _backend_ e _frontend_;
2. Relembrar o papel das camadas de controle (_Controller_) e apresentação (_View_) na arquitetura MVC;
3. Entender o que são Java Servlets e como eles podem ser utilizados para implementar a camada de controle (_Controller_) em aplicações web Java;
   3.1 Implementar a camada de controle (_Controller_) para nossa aplicação de exemplo de refeições por meio das operações CRUD HTTP (GET, POST, PUT, DELETE) utilizando Java Servlets para construir uma API simples no _backend_;
4. Entender o que é a camada de apresentação (_View_) e como ela pode ser implementada como _frontend_ de forma _client-side_ (apenas no navegador do usuário) utilizando HTML, CSS e JavaScript;
   4.1 Adaptar uma camada de apresentação (_View_) para nossa aplicação de exemplo de refeições utilizando HTML, CSS e JavaScript para construir uma interface simples no _frontend_.

## Pré-requisitos

Antes de prosseguir, certifique-se de que você tem o seguinte ambiente configurado:

1. Java Development Kit (JDK) instalado (versão 17 ou superior).
2. VSCode instalado com a extensão "Extension Pack for Java".
3. Extensão Red Hat Community Server Connectors.
4. Maven instalado e configurado no PATH do seu sistema.

Como nas aulas passadas já fizemos os passos 1 e 2, faremos a partir do passo 3 agora.

## Configuração do Ambiente

1. No VSCode, abra o painel de extensões (Ctrl+Shift+X) e procure por "Red Hat Community Server Connectors". Instale a extensão e reinicie o VSCode se necessário.
2. Baixe e descompacte o Maven [(https://dlcdn.apache.org/maven/maven-3/3.9.12/binaries/apache-maven-3.9.12-bin.zip)](https://dlcdn.apache.org/maven/maven-3/3.9.12/binaries/apache-maven-3.9.12-bin.zip) em um diretório de sua preferência.
3. Adicione o diretório `bin` do Maven ao PATH do seu sistema:
    - No Windows:
        - Abra o Painel de Controle e vá para "Sistema e Segurança" > "Sistema" > "Configurações avançadas do sistema".
        - Clique em "Variáveis de Ambiente".
        - Na seção "Variáveis do sistema", encontre a variável "Path" e clique em "Editar".
        - Adicione o caminho completo para o diretório `bin` do Maven (por exemplo, `C:\apache-maven-3.9.12\bin`).
        - Clique em "OK" para salvar as alterações.
4. Verifique a instalação do Maven abrindo um terminal e executando o comando `mvn -v`. Você deve ver a versão do Maven instalada.

Instalados o Maven e a extensão Red Hat Community Server Connectors, podemos prosseguir para baixar o template (_archetype_) do projeto web para nossa aplicação.

## Criando o Projeto Web com Maven

0. Feche todos os projetos abertos no VSCode para evitar conflitos.
1. Abra um terminal no VSCode (Ctrl+`).
2. Vá para o diretório onde deseja criar o projeto, por exemplo, o diretório `Desktop`:

```bat
cd $HOME\Desktop
```

3. Execute o comando abaixo:

```powershell
mvn archetype:generate "-DarchetypeGroupId=io.github.diegoascanio" `
                       "-DarchetypeArtifactId=webapp-cefetmg" `
                       "-DarchetypeVersion=1.0.5" `
                       "-DgroupId=br.cefetmg" `
                       "-DartifactId=webapp" `
                       "-Dversion=1.0.0"
```

4. O maven irá perguntar se você deseja usar as configurações informadas. Digite `Y` e pressione Enter.
5. Após a conclusão do comando, abra o projeto recém-baixado no VSCode:

-   Vá para "File" > "Open Folder..." e selecione a pasta `webapp` que foi criada na área de trabalho.

## Estrutura do Projeto

A estrutura do projeto Maven para aplicações web é a seguinte:

```bash
.
├── pom.xml
└── src
    └── main
        ├── java
        │   ├── controllers
        │   │   └── BasicController.java
        │   ├── models
        │   │   └── BasicModel.java
        │   └── repositories
        │       ├── BasicRepo.java
        │       └── BasicRepoMemory.java
        └── webapp
            ├── basic
            │   └── index.html
            ├── index.html
            └── WEB-INF
                └── web.xml
```

O arquivo pom.xml contém as dependências e configurações do projeto para que o Maven possa gerenciar a construção e execução da aplicação web, então aqui entra o JDBC, junit (para testes) e outras bibliotecas que possam ser necessárias.

Temos um modelo padrão BasicModel.java que representa um `host` genérico com `hostname` e `username`, uma interface de repositório BasicRepo.java e uma implementação em memória BasicRepoMemory.java que permite armazenar e recuperar instâncias de BasicModel na memória principal.

Temos o controller BasicController.java que lida com requisições HTTP por meio de servlets e interage com o repositório para realizar operações CRUD no repositório de hosts.

Temos uma view de BasicModel implementada em `src/main/webapp/basic/index.html` que é a página onde é possível interagir com o backend e executar operações CRUD de instâncias do modelo Basic por meio do HTTP.

Temos uma página principal em `src/main/webapp/index.html` que é a página inicial da aplicação web, ela contém inicialmente apenas um link para a view de BasicModel, mas, depois, vamos adicionar outro link para a view de refeições que iremos criar.

Por fim, temos o arquivo web.xml em `src/main/webapp/WEB-INF/web.xml` que é o arquivo de configuração do servlet que mapeia as URLs para os servlets (ou views - arquivos html) correspondentes.

## Executando a Aplicação WEB

1. No terminal do VSCode, certifique-se de que você está no diretório raiz do projeto (onde está o arquivo `pom.xml`).
2. Execute o comando abaixo para compilar a aplicação web:
    ```powershell
    mvn clean package
    ```
3. Adicione um servidor Tomcat 9.0.41 no Community Server Connectors:
    - Abra o painel de servidores do projeto (ícone de servidor na barra lateral esquerda).
    - Clique em "Create New Server".
    - Responda "Yes" para "download server?".
    - Em "Please choose a server to download", digite "Apache Tomcat 9.0.41" e selecione-o.
    - Clique em "Continue" para avançar ao próximo passo.
    - Aceite a licença, clicando em "Yes".
    - Inicie o servidor Tomcat clicando com o botão direito no servidor e selecionando "Start Server".
4. Após o servidor iniciar, implante a aplicação web:
    - Na pasta `target` do projeto, localize o arquivo `webapp.war`.
    - Clique com o botão direito no arquivo `webapp.war` e selecione "Run on Server".
    - Selecione o servidor Tomcat que você acabou de criar.
    - Clique em "No" para "Do you want to edit parameters?".
5. Acesse a aplicação web no navegador:
    - Abra o navegador e vá para `http://localhost:8080/webapp/`.
    - Você verá a página inicial da aplicação web com um link para a view de BasicModel.

Clique no link e interaja com a aplicação para testar as operações CRUD de BasicModel, estas operações são realizadas na memória principal, ou seja, os dados não são persistidos em um banco de dados. Vamos usar este painel de manipulação de BasicModel como referência para criar a aplicação de refeições em sequência.

---

## Aplicação de Refeições

### Banco de Dados

**Pré-requisito:** Ter o MariaDB instalado e em execução na sua máquina, com um software para gerenciamento do banco de dados, como o HeidiSQL ou o próprio mariadb client.

Vamos agora configurar o banco de dados sql para armazenar nossas refeições, eis o passo a passo:

1. Baixe o script de criação do banco de dados e da tabela de refeições [bd.sql](sql/bd.sql).
2. Abra o HeidiSQL (ou outro software de sua preferência) e conecte-se ao servidor MariaDB.
3. Execute o conteúdo do arquivo `bd.sql` para criar o banco de dados `refeicoes` e a tabela `refeicao`.

### Inserindo o modelo Refeição e seu repositório na aplicação.

À partir do modelo refeição e do repositório de refeições, que já criamos nas aulas anteriores, vamos inserir estes arquivos na estrutura do projeto web que acabamos de criar.

Na pasta `src/main/java/models`, crie o arquivo `Refeicao.java` com o seguinte conteúdo:

```java
package models;

import java.time.LocalDate;
import java.util.Objects;

public class Refeicao {
    private String idCartaoEstudante;
    private LocalDate dataRefeicao;

    public Refeicao(String idCartaoEstudante, LocalDate dataRefeicao) {
        this.idCartaoEstudante = idCartaoEstudante;
        this.dataRefeicao = dataRefeicao;
    }

    public String getIdCartaoEstudante() {
        return idCartaoEstudante;
    }

    public void setIdCartaoEstudante(String idCartaoEstudante) {
        this.idCartaoEstudante = idCartaoEstudante;
    }

    public LocalDate getDataRefeicao() {
        return dataRefeicao;
    }

    public void setDataRefeicao(LocalDate dataRefeicao) {
        this.dataRefeicao = dataRefeicao;
    }

    @Override
    public String toString() {
        return "Refeicao{" +
                "idCartaoEstudante='" + idCartaoEstudante + '\'' +
                ", dataRefeicao=" + dataRefeicao +
                '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Refeicao refeicao = (Refeicao) obj;
        return Objects.equals(idCartaoEstudante, refeicao.idCartaoEstudante) &&
               Objects.equals(dataRefeicao, refeicao.dataRefeicao);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idCartaoEstudante, dataRefeicao);
    }
}
```

Agora, na pasta `src/main/java/repositories`, crie a interface `RefeicaoRepo.java` com o seguinte conteúdo:

```java
package repositories;

import models.Refeicao;
import java.time.LocalDate;
import java.util.List;

public interface RefeicaoRepo {
    void create(Refeicao refeicao); // Create
    Refeicao retrieve(String idCartaoEstudante, LocalDate data); // Read / Retrieve (retorna a primeira encontrada)
    List<Refeicao> retrieveByCartao(String cartao); // Read / Retrieve pela presença de um cartão
    List<Refeicao> retrieveByData(LocalDate data); // Read / Retrieve pela presença de uma data
    List<Refeicao> retrieveAll(); // Read / Retrieve all
    void update(Refeicao oldRefeicao, Refeicao newRefeicao); // Update substituindo a refeição especificada
    void delete(Refeicao refeicao); // Delete (remove a refeição especificada)
}
```

Em sequência, crie a implementação do repositório em memória `RefeicaoRepoSQL.java` com o seguinte conteúdo:

```java
package repositories;
import models.Refeicao;

import java.util.List;
import java.sql.*;
import java.time.LocalDate;

public class RefeicaoRepoSQL implements RefeicaoRepo {

    private Connection con; // mantida enquanto o repositório estiver em usoprivate Connection con; // mantida enquanto o repositório estiver em uso
    private final String url;
    private final String user;
    private final String pass;

    public RefeicaoRepoSQL() { // mariadb hardcoded
        this.url = "jdbc:mariadb://localhost:3306/refeicoes";
        this.user = "aluno";
        this.pass = "123456";
        this.openConnection();
    }

    public RefeicaoRepoSQL(String url) { // sqlite
        this.url = url;
        this.user = null;
        this.pass = null;
        this.openConnection();
    }

    // generico (mariadb, postgres, sqlserver), exceto sqlite
    public RefeicaoRepoSQL(String url, String user, String pass) {
        this.url = url;
        this.user = user;
        this.pass = pass;
        this.openConnection();
    }

    private void openConnection() {
        // Força registro do driver no DriverManager (muito útil em webapp/Tomcat)
        try {
            if (url.startsWith("jdbc:mariadb:")) {
            Class.forName("org.mariadb.jdbc.Driver");
            } else if (url.startsWith("jdbc:postgresql:")) {
                Class.forName("org.postgresql.Driver");
            } else if (url.startsWith("jdbc:sqlserver:")) {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            } else if (url.startsWith("jdbc:sqlite:")) {
                Class.forName("org.sqlite.JDBC");
            } else {
                throw new RuntimeException("URL JDBC não suportada: " + url);
            }
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver JDBC não encontrado para a URL: " + url, e);
        } 
        if (this.con != null) return; // já aberta
        try {
            if (user == null && pass == null) {
                this.con = DriverManager.getConnection(url);     // ex.: SQLite
            } else {
                this.con = DriverManager.getConnection(url, user, pass);
            }
            // this.con.setAutoCommit(true); // default
        } catch (SQLException e) {
            throw new RuntimeException("Falha ao abrir conexão JDBC", e);
        }
    }

    private void closeConnection() {
        if (this.con != null) {
            try { if (!this.con.isClosed()) this.con.close(); }
            catch (SQLException ignored) {}
            finally { this.con = null; }
        }
    }

    // Método auxiliar para fechar recursos (para Update e Delete)
    private void closePreparedStatement(PreparedStatement ps) {
        if (ps != null) { try { ps.close(); } catch (SQLException ignored) {} }
    }

    @Override
    public void finalize() {
        // 1. encerrar a conexao
        this.closeConnection();
    }

    @Override
    public void create(Refeicao r) {
        PreparedStatement ps = null;
        try {
            String sql = "INSERT INTO refeicao (id_cartao, data_refeicao) values (?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, r.getIdCartaoEstudante());
            ps.setDate(2, Date.valueOf(r.getDataRefeicao()));
            ps.executeUpdate();
        } catch (SQLIntegrityConstraintViolationException dup) {
            throw new IllegalArgumentException("Refeição já registrada para este estudante nesta data.", dup);
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao inserir refeição", e);
        } finally {
            if (ps != null) { try { ps.close(); } catch (SQLException ignored) {} }
        }
    }


    @Override
    public void delete(Refeicao refeicao) {
        PreparedStatement ps = null;
        try {
            // A interface pede para remover TODAS as refeições com este ID
            String sql = "DELETE FROM refeicao WHERE id_cartao = ? AND data_refeicao = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, refeicao.getIdCartaoEstudante());
            ps.setDate(2, Date.valueOf(refeicao.getDataRefeicao()));
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                 // Pode ser tratado como sucesso ou aviso, dependendo da regra de negócio.
                 // Aqui, vamos apenas registrar que nenhuma refeição foi encontrada para deleção.
                 System.out.println("Aviso: Nenhuma refeição encontrada para o ID " +  refeicao.getIdCartaoEstudante() + ".");
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao deletar refeições por ID", e);
        } finally {
            closePreparedStatement(ps);
        }
    }

    @Override
    public List<Refeicao> retrieveAll() {
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Refeicao> out = new java.util.ArrayList<>();
        try {
            String sql = "SELECT id_cartao, data_refeicao FROM refeicao ORDER BY data_refeicao DESC, id_cartao";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                out.add(new Refeicao(
                    rs.getString("id_cartao"),
                    rs.getDate("data_refeicao").toLocalDate()
                ));
            }
            return out;
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao listar refeições", e);
        } finally {
            if (rs != null) { try { rs.close(); } catch (SQLException ignored) {} }
            closePreparedStatement(ps);
        }
    }

    @Override
    public void update(Refeicao oldRefeicao, Refeicao newRefeicao) {
        PreparedStatement ps = null;
        try {
            // Atualiza o ID e a Data da refeição. A chave composta anterior é a "oldRefeicao".
            String sql = "UPDATE refeicao SET id_cartao = ?, data_refeicao = ? WHERE id_cartao = ? AND data_refeicao = ?";
            ps = con.prepareStatement(sql);

            // Novos valores
            ps.setString(1, newRefeicao.getIdCartaoEstudante());
            ps.setDate(2, Date.valueOf(newRefeicao.getDataRefeicao()));

            // Chave da refeição a ser atualizada (Old Refeicao)
            ps.setString(3, oldRefeicao.getIdCartaoEstudante());
            ps.setDate(4, Date.valueOf(oldRefeicao.getDataRefeicao()));

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected == 0) {
                throw new IllegalArgumentException("Refeição a ser atualizada não encontrada (ID ou Data incorretos).");
            }
            // Se tentar mudar a chave para uma já existente, o BD lança SQLIntegrityConstraintViolationException

        } catch (SQLIntegrityConstraintViolationException dup) {
            throw new IllegalArgumentException("Nova refeição já existe (duplicidade de chave).", dup);
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao atualizar refeição", e);
        } finally {
            closePreparedStatement(ps);
        }
    }

    @Override
    public Refeicao retrieve(String idCartaoEstudante, LocalDate data) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT id_cartao, data_refeicao FROM refeicao WHERE id_cartao = ? AND data_refeicao = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, idCartaoEstudante);
            ps.setDate(2, Date.valueOf(data));
            rs = ps.executeQuery();
            if (rs.next()) {
                return new Refeicao(
                    rs.getString("id_cartao"),
                    rs.getDate("data_refeicao").toLocalDate()
                );
            }
            return null;
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao recuperar refeição", e);
        } finally {
            if (rs != null) { try { rs.close(); } catch (SQLException ignored) {} }
            if (ps != null) { try { ps.close(); } catch (SQLException ignored) {} }
        }
    }

    @Override
    public List<Refeicao> retrieveByCartao(String cartao) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Refeicao> out = new java.util.ArrayList<>();
        try {
            String sql = "SELECT id_cartao, data_refeicao FROM refeicao WHERE id_cartao = ? ORDER BY data_refeicao DESC";
            ps = con.prepareStatement(sql);
            ps.setString(1, cartao);
            rs = ps.executeQuery();
            while (rs.next()) {
                out.add(new Refeicao(
                    rs.getString("id_cartao"),
                    rs.getDate("data_refeicao").toLocalDate()
                ));
            }
            return out;
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao recuperar refeições por cartão", e);
        } finally {
            if (rs != null) { try { rs.close(); } catch (SQLException ignored) {} }
            closePreparedStatement(ps);
        }
    }

    @Override
    public List<Refeicao> retrieveByData(LocalDate data) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Refeicao> out = new java.util.ArrayList<>();
        try {
            String sql = "SELECT id_cartao, data_refeicao FROM refeicao WHERE data_refeicao = ? ORDER BY id_cartao";
            ps = con.prepareStatement(sql);
            ps.setDate(1, Date.valueOf(data));
            rs = ps.executeQuery();
            while (rs.next()) {
                out.add(new Refeicao(
                    rs.getString("id_cartao"),
                    rs.getDate("data_refeicao").toLocalDate()
                ));
            }
            return out;
        } catch (SQLException e) {
            throw new RuntimeException("Erro ao recuperar refeições por data", e);
        } finally {
            if (rs != null) { try { rs.close(); } catch (SQLException ignored) {} }
            closePreparedStatement(ps);
        }
    }

}
```

---

### Controller de refeições - Operações CRUD via HTTP por meio de Servlets

Servlets são classes Java que abstraem funcionalidades de servidores web, permitindo que programadores possam criar de forma facilitada — sem se preocupar com detalhes de baixo nível — aplicações que respondam a requisições HTTP.

Vamos construir um RefeicaoController.java que implementa as operações CRUD via HTTP (GET, POST, PUT, DELETE) para nossa aplicação de refeições.

Para isso, crie o arquivo `RefeicaoController.java` na pasta `src/main/java/controllers` com o seguinte conteúdo:

```java
package controllers;

import models.Refeicao;
import repositories.RefeicaoRepo;
import repositories.RefeicaoRepoSQL;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RefeicaoController extends HttpServlet {
    private RefeicaoRepo repo;
    
    @Override
    public void init() throws ServletException {
        // Configuração hardcoded para MariaDB local
        // Não é a melhor prática para produção, pois, expõe credenciais
        // credenciais no código fonte, mas, é suficiente para nosso exemplo
        // didático.
        String dbUrl = "jdbc:mariadb://localhost:3306/refeicoes";
        String dbUser = "root"; // trocar conforme seu setup
        String dbPass = "123456"; // trocar conforme seu setup
        this.repo = new RefeicaoRepoSQL(dbUrl, dbUser, dbPass);
    }
}

```

As classes servlet de Java usam um tipo especial de ciclo de vida, onde o contêiner web (servidor) instancia a servlet e chama o método `init()` uma vez para inicialização. Depois disso, para cada requisição HTTP recebida, o contêiner chama o método correspondente ao verbo HTTP (doGet, doPost, doPut, doDelete, etc.). Nesse caso, o init() é como se fosse o construtor implicito da nossa classe RefeicaoController, onde inicializamos o repositório de refeições.

#### Controller de Refeições - Adicionando refeições (operação create) via método POST do HTTP

Sabemos, de aulas passadas, que a operação HTTP correspondente à criação de um novo recurso é o método POST. Vamos implementar o método `doPost()` na nossa servlet RefeicaoController para lidar com requisições HTTP POST e adicionar novas refeições ao repositório.

Na classe `src/main/java/br/cefetmg/controllers/RefeicaoController.java`, adicione o seguinte método:

```java
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idCartaoEstudante = request.getParameter("idCartaoEstudante");
        String dataRefeicaoStr = request.getParameter("dataRefeicao");

        if (idCartaoEstudante == null || dataRefeicaoStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parâmetros idCartaoEstudante e dataRefeicao são obrigatórios.");
            return;
        }

        try {
            LocalDate dataRefeicao = LocalDate.parse(dataRefeicaoStr);
            Refeicao novaRefeicao = new Refeicao(idCartaoEstudante, dataRefeicao);
            repo.create(novaRefeicao);
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write("Refeição adicionada com sucesso.");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao adicionar refeição: " + e.getMessage());
        }
    }
```

Esse método instrui o Servlet a tratar requisições do tipo POST, extraindo os parâmetros `idCartaoEstudante` e `dataRefeicao` da requisição, criando uma nova instância de Refeicao e adicionando-a ao repositório. Se a operação for bem-sucedida, ele retorna um status HTTP 201 (Created). Caso contrário, retorna um erro apropriado.

#### Controller de Refeições - Listando refeições (operação read) via método GET do HTTP

Sabemos de aulas passadas que o método GET do HTTP é que é utilizado para fazer as operações de leitura (read) dos recursos. Ele pode ou não receber parâmetros na URL para filtrar os resultados e, a partir destes parâmetros, é que devemos decidir quais métodos de retrieve do repositório devemos chamar. Portanto, ao implementar o método doGet(), devemos considerar os seguintes casos:

1. Se nenhum parâmetro for fornecido, retornamos todas as refeições (retrieveAll).
2. Se apenas o parâmetro idCartaoEstudante for fornecido, retornamos todas as refeições associadas a esse cartão (retrieveByCartao).
3. Se apenas o parâmetro dataRefeicao for fornecido, retornamos todas as refeições associadas a essa data (retrieveByData).
4. Se ambos os parâmetros forem fornecidos, retornamos a refeição específica correspondente a esse cartão e data (retrieve).

```java
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idCartaoEstudante = request.getParameter("idCartaoEstudante");
        String dataRefeicaoStr = request.getParameter("dataRefeicao");

        response.setContentType("application/json");
        List<Refeicao> refeicoes = new ArrayList<>();

        try {
            if (idCartaoEstudante == null && dataRefeicaoStr == null) {
                // Caso 1: Nenhum parâmetro fornecido
                refeicoes = repo.retrieveAll();
            } else if (idCartaoEstudante != null && dataRefeicaoStr == null) {
                // Caso 2: Apenas idCartaoEstudante fornecido
                refeicoes = repo.retrieveByCartao(idCartaoEstudante);
            } else if (idCartaoEstudante == null && dataRefeicaoStr != null) {
                // Caso 3: Apenas dataRefeicao fornecido
                LocalDate dataRefeicao = LocalDate.parse(dataRefeicaoStr);
                refeicoes = repo.retrieveByData(dataRefeicao);
            } else {
                // Caso 4: Ambos os parâmetros fornecidos
                LocalDate dataRefeicao = LocalDate.parse(dataRefeicaoStr);
                Refeicao refeicao = repo.retrieve(idCartaoEstudante, dataRefeicao);
                if (refeicao != null) {
                    refeicoes.add(refeicao);
                }
            }

            // Converter a lista de refeições para JSON, usando StringBuilder json
		    response.setContentType("application/json");
            // I want to show status as success only if there are refeicoes found
            if (refeicoes.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"status\":\"not found\",\"refeicoes\":[]}");
            } else {
                response.setStatus(HttpServletResponse.SC_OK);
                StringBuilder json = new StringBuilder();
                json.append("{\"status\":\"success\",\"refeicoes\":[");
                for (int i = 0; i < refeicoes.size(); i++) {
                    Refeicao r = refeicoes.get(i);
                    json.append("{");
                    json.append("\"idCartaoEstudante\":\"").append(r.getIdCartaoEstudante()).append("\",");
                    json.append("\"dataRefeicao\":\"").append(r.getDataRefeicao().toString()).append("\"");
                    json.append("}");
                    if (i < refeicoes.size() - 1) {
                        json.append(",");
                    }
                }
                json.append("]}");
                response.getWriter().write(json.toString());
            }
            response.getWriter().flush();
            return;
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao recuperar refeições: " + e.getMessage());
        }
    }

```

#### Controller de Refeições - Atualizando refeições (operação update) via método PUT do HTTP

Nesta operação vamos receber como parâmetros na API 4 valores: 

- oldIdCartaoEstudante (equivalente ao idCartaoEstudante atual da refeição a ser atualizada),
- oldDataRefeicao (equivalente à dataRefeicao atual da refeição a ser atualizada),
- newIdCartaoEstudante (equivalente ao novo idCartaoEstudante que substituirá o atual) e
- newDataRefeicao (equivalente à nova dataRefeicao que substituirá a atual).

O método doPut do controller irá construir dois objetos Refeicao (oldRefeicao e newRefeicao) e chamar o método update do repositório para atualizar a refeição.

```java
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String oldIdCartaoEstudante = request.getParameter("oldIdCartaoEstudante");
        String oldDataRefeicaoStr = request.getParameter("oldDataRefeicao");
        String newIdCartaoEstudante = request.getParameter("newIdCartaoEstudante");
        String newDataRefeicaoStr = request.getParameter("newDataRefeicao");

        if (oldIdCartaoEstudante == null || oldDataRefeicaoStr == null ||
            newIdCartaoEstudante == null || newDataRefeicaoStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parâmetros oldIdCartaoEstudante, oldDataRefeicao, newIdCartaoEstudante e newDataRefeicao são obrigatórios.");
            return;
        }

        try {
            LocalDate oldDataRefeicao = LocalDate.parse(oldDataRefeicaoStr);
            LocalDate newDataRefeicao = LocalDate.parse(newDataRefeicaoStr);

            Refeicao oldRefeicao = new Refeicao(oldIdCartaoEstudante, oldDataRefeicao);
            Refeicao newRefeicao = new Refeicao(newIdCartaoEstudante, newDataRefeicao);

            repo.update(oldRefeicao, newRefeicao);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Refeição atualizada com sucesso.");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao atualizar refeição: " + e.getMessage());
        }
    }
```

#### Controller de Refeições - Deletando refeições (operação delete) via método DELETE do HTTP

No caso corrente, para deletarmos uma refeição, só o realizaremos se forem informados tanto idCartaoEstudante quanto dataRefeicao, para que possamos identificar unicamente a refeição a ser removida.

```java
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idCartaoEstudante = request.getParameter("idCartaoEstudante");
        String dataRefeicaoStr = request.getParameter("dataRefeicao");

        if (idCartaoEstudante == null || dataRefeicaoStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parâmetros idCartaoEstudante e dataRefeicao são obrigatórios.");
            return;
        }

        try {
            LocalDate dataRefeicao = LocalDate.parse(dataRefeicaoStr);
            Refeicao refeicaoToDelete = new Refeicao(idCartaoEstudante, dataRefeicao);
            repo.delete(refeicaoToDelete);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Refeição deletada com sucesso se ela existia no banco de dados.");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Erro ao deletar refeição: " + e.getMessage());
        }
    }
```

#### Controller de Refeições - Registrando o servlet no web.xml

Finalizadas as implementações das operações CRUD via HTTP no RefeicaoController, precisamos registrar o servlet no arquivo web.xml para que o contêiner web (servidor) saiba como mapear as requisições HTTP para a nossa servlet. Para isso, vamos editar o arquivo web.xml, responsável por mapear as rotas (URLs) para os servlets (ou views - arquivos html) correspondentes.

Abra o arquivo `src/main/webapp/WEB-INF/web.xml` e adicione o seguinte mapeamento para o RefeicaoController servlet, abaixo do mapeamento já existente para o BasicController e acima da tag `<welcome-file-list>`:

```xml

  <servlet>
    <servlet-name>RefeicaoController</servlet-name>
    <servlet-class>controllers.RefeicaoController</servlet-class>
  </servlet>
  
  <servlet-mapping>
    <servlet-name>RefeicaoController</servlet-name>
    <url-pattern>/refeicao/api</url-pattern>
  </servlet-mapping>
```

Feito isso, temos um controller funcional para criar, ler, atualizar e deletar refeições via HTTP. Agora precisamos de uma interface para que o usuário comum possa registrar suas refeições de forma amigável. Inspirados na interface de BasicModel, vamos criar uma view para Refeição.

---

### View de Refeições - Interface HTML para interagir com o RefeicaoController

A _view_ de refeições será uma página HTML simples que permitirá aos usuários interagir com o RefeicaoController para realizar operações CRUD de refeições. Bastante similar à view de BasicModel, disponível em `src/main/webapp/basic/index.html`, nossa view de refeições estará localizada em `src/main/webapp/refeicao/index.html`. Poranto:

1. Crie a pasta `refeicao` dentro de `src/main/webapp/`:
  - `mkdir src/main/webapp/refeicao`
2. Crie um arquivo `index.html` dentro da pasta `refeicao`.
3. Adicione a ele o conteúdo abaixo:

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CRUD de Refeições</title>
  <link href="style.css" rel="stylesheet" />
</head>
<body>
  <div class="container">
    <h1>🍲 CRUD de Refeições</h1>

    <div class="operations-grid">
      <!-- GET ALL -->
      <div class="operation-card">
        <h2><span class="http-method get-method">GET</span> Listar todas</h2>
        <p>Recupera todos os registros</p>
        <div class="button-group">
          <button class="btn-primary" onclick="fetchAll()">Buscar tudo</button>
        </div>
        <div id="getall-response" class="response-display" style="display: none; margin-top: 10px;"></div>
      </div>

      <!-- GET por idCartaoEstudante + dataRefeicao -->
      <div class="operation-card">
        <h2><span class="http-method get-method">GET</span> Por cartão + data</h2>
        <p>Busca uma refeição pelo id do cartão e pela data</p>

        <div class="form-group">
          <label for="getByBoth-idCartaoEstudante">idCartaoEstudante:</label>
          <input type="text" id="getByBoth-idCartaoEstudante" placeholder="Ex.: 112233AA" />
        </div>

        <div class="form-group">
          <label for="getByBoth-dataRefeicao">dataRefeicao (YYYY-MM-DD):</label>
          <input type="text" id="getByBoth-dataRefeicao" placeholder="Ex.: 2025-12-18" />
        </div>

        <div class="button-group">
          <button class="btn-primary" onclick="fetchByIdCartaoDataRefeicao()">Buscar</button>
          <button class="btn-secondary" onclick="clearInput('getByBoth-idCartaoEstudante', 'getByBoth-dataRefeicao')">Limpar</button>
        </div>

        <div id="getByBoth-response" class="response-display" style="display: none; margin-top: 10px;"></div>
      </div>

      <!-- GET por idCartaoEstudante -->
      <div class="operation-card">
        <h2><span class="http-method get-method">GET</span> Por cartão</h2>
        <p>Busca refeições pelo id do cartão</p>

        <div class="form-group">
          <label for="getByCartao-idCartaoEstudante">idCartaoEstudante:</label>
          <input type="text" id="getByCartao-idCartaoEstudante" placeholder="Ex.: 112233AA" />
        </div>

        <div class="button-group">
          <button class="btn-primary" onclick="fetchByIdCartao()">Buscar</button>
          <button class="btn-secondary" onclick="clearInput('getByCartao-idCartaoEstudante')">Limpar</button>
        </div>

        <div id="getByCartao-response" class="response-display" style="display: none; margin-top: 10px;"></div>
      </div>

      <!-- GET por dataRefeicao -->
      <div class="operation-card">
        <h2><span class="http-method get-method">GET</span> Por data</h2>
        <p>Busca refeições pela data</p>

        <div class="form-group">
          <label for="getByData-dataRefeicao">dataRefeicao (YYYY-MM-DD):</label>
          <input type="text" id="getByData-dataRefeicao" placeholder="Ex.: 2025-12-18" />
        </div>

        <div class="button-group">
          <button class="btn-primary" onclick="fetchByDataRefeicao()">Buscar</button>
          <button class="btn-secondary" onclick="clearInput('getByData-dataRefeicao')">Limpar</button>
        </div>

        <div id="getByData-response" class="response-display" style="display: none; margin-top: 10px;"></div>
      </div>

      <!-- POST CREATE -->
      <div class="operation-card">
        <h2><span class="http-method post-method">POST</span> Criar</h2>
        <p>Cria uma nova refeição</p>

        <div class="form-group">
          <label for="post-idCartaoEstudante">idCartaoEstudante:</label>
          <input type="text" id="post-idCartaoEstudante" placeholder="Ex.: 112233AA" />
        </div>

        <div class="form-group">
          <label for="post-dataRefeicao">dataRefeicao (YYYY-MM-DD):</label>
          <input type="text" id="post-dataRefeicao" placeholder="Ex.: 2025-12-18" />
        </div>

        <div class="button-group">
          <button class="btn-primary" onclick="createRecord()">Criar</button>
          <button class="btn-secondary" onclick="clearInput('post-idCartaoEstudante', 'post-dataRefeicao')">Limpar</button>
        </div>

        <div id="post-response" class="response-display" style="display: none; margin-top: 10px;"></div>
      </div>

      <!-- PUT UPDATE -->
      <div class="operation-card">
        <h2><span class="http-method put-method">PUT</span> Atualizar</h2>
        <p>Atualiza uma refeição existente</p>

        <div class="form-group">
          <label for="put-oldIdCartaoEstudante">oldIdCartaoEstudante:</label>
          <input type="text" id="put-oldIdCartaoEstudante" placeholder="Id do cartão atual" />
        </div>

        <div class="form-group">
          <label for="put-oldDataRefeicao">oldDataRefeicao (YYYY-MM-DD):</label>
          <input type="text" id="put-oldDataRefeicao" placeholder="Data atual" />
        </div>

        <div class="form-group">
          <label for="put-newIdCartaoEstudante">newIdCartaoEstudante:</label>
          <input type="text" id="put-newIdCartaoEstudante" placeholder="Novo id do cartão" />
        </div>

        <div class="form-group">
          <label for="put-newDataRefeicao">newDataRefeicao (YYYY-MM-DD):</label>
          <input type="text" id="put-newDataRefeicao" placeholder="Nova data" />
        </div>

        <div class="button-group">
          <button class="btn-primary" onclick="updateRecord()">Atualizar</button>
          <button class="btn-secondary" onclick="clearInput('put-oldIdCartaoEstudante', 'put-oldDataRefeicao', 'put-newIdCartaoEstudante', 'put-newDataRefeicao')">Limpar</button>
        </div>

        <div id="put-response" class="response-display" style="display: none; margin-top: 10px;"></div>
      </div>

      <!-- DELETE -->
      <div class="operation-card">
        <h2><span class="http-method delete-method">DELETE</span> Deletar</h2>
        <p>Deleta uma refeição pelo id do cartão e data</p>

        <div class="form-group">
          <label for="delete-idCartaoEstudante">idCartaoEstudante:</label>
          <input type="text" id="delete-idCartaoEstudante" placeholder="Ex.: 112233AA" />
        </div>

        <div class="form-group">
          <label for="delete-dataRefeicao">dataRefeicao (YYYY-MM-DD):</label>
          <input type="text" id="delete-dataRefeicao" placeholder="Ex.: 2025-12-18" />
        </div>

        <div class="button-group">
          <button class="btn-primary" onclick="deleteRecord()">Deletar</button>
          <button class="btn-secondary" onclick="clearInput('delete-idCartaoEstudante', 'delete-dataRefeicao')">Limpar</button>
        </div>

        <div id="delete-response" class="response-display" style="display: none; margin-top: 10px;"></div>
      </div>
    </div>

    <!-- Response Summary -->
    <div class="response-section">
      <h3>📋 Operation Log</h3>
      <div id="log-display" class="response-display">
        <span class="loading">No operations yet. Start by clicking any button above!</span>
      </div>
    </div>
  </div>

  <script src="script.js"></script>
</body>
</html>
```

Ainda na pasta `src/main/webapp/refeicao/`, crie o arquivo `style.css` com o seguinte conteúdo para estilizar a página:

```css
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    padding: 20px;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    background: white;
    border-radius: 10px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
    padding: 30px;
}

h1 {
    text-align: center;
    color: #333;
    margin-bottom: 30px;
    font-size: 2.5em;
}

.operations-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.operation-card {
    background: #f8f9fa;
    border: 2px solid #e9ecef;
    border-radius: 8px;
    padding: 20px;
    transition: all 0.3s ease;
}

.operation-card:hover {
    border-color: #667eea;
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.1);
}

.operation-card h2 {
    color: #667eea;
    font-size: 1.3em;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.operation-card p {
    color: #6c757d;
    margin-bottom: 15px;
    font-size: 0.9em;
}

.http-method {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 0.8em;
    font-weight: bold;
    color: white;
}

.get-method {
    background: #17a2b8;
}

.post-method {
    background: #28a745;
}

.put-method {
    background: #ffc107;
    color: #333;
}

.delete-method {
    background: #dc3545;
}

.form-group {
    margin-bottom: 12px;
}

label {
    display: block;
    margin-bottom: 5px;
    color: #495057;
    font-weight: 500;
    font-size: 0.9em;
}

input[type="text"] {
    width: 100%;
    padding: 10px;
    border: 1px solid #ced4da;
    border-radius: 4px;
    font-size: 0.9em;
    transition: border-color 0.2s;
}

input[type="text"]:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.button-group {
    display: flex;
    gap: 10px;
    margin-top: 15px;
}

button {
    flex: 1;
    padding: 10px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: bold;
    transition: all 0.2s;
    font-size: 0.9em;
}

.btn-primary {
    background: #667eea;
    color: white;
}

.btn-primary:hover {
    background: #5568d3;
    transform: translateY(-2px);
    box-shadow: 0 5px 10px rgba(102, 126, 234, 0.3);
}

.btn-primary:active {
    transform: translateY(0);
}

.btn-secondary {
    background: #6c757d;
    color: white;
}

.btn-secondary:hover {
    background: #5a6268;
}

.response-section {
    margin-top: 30px;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 8px;
    border: 2px solid #e9ecef;
}

.response-section h3 {
    color: #333;
    margin-bottom: 15px;
    font-size: 1.1em;
}

.response-display {
    background: white;
    border: 1px solid #dee2e6;
    border-radius: 4px;
    padding: 15px;
    margin-bottom: 10px;
    max-height: 300px;
    overflow-y: auto;
    font-family: 'Courier New', monospace;
    font-size: 0.85em;
    line-height: 1.6;
}

.response-display.success {
    border-left: 4px solid #28a745;
    background: #f0f7f4;
}

.response-display.error {
    border-left: 4px solid #dc3545;
    background: #fdf5f5;
}

.response-display.info {
    border-left: 4px solid #17a2b8;
    background: #f0f8fb;
}

.loading {
    color: #667eea;
    font-style: italic;
}

.status-code {
    display: inline-block;
    padding: 4px 8px;
    border-radius: 3px;
    margin-right: 10px;
    font-weight: bold;
    font-size: 0.85em;
}

.status-success {
    background: #d4edda;
    color: #155724;
}

.status-error {
    background: #f8d7da;
    color: #721c24;
}

.status-info {
    background: #d1ecf1;
    color: #0c5460;
}

.timestamp {
    color: #6c757d;
    font-size: 0.8em;
    margin-top: 10px;
}

@media (max-width: 768px) {
    .container {
        padding: 15px;
    }

    h1 {
        font-size: 1.8em;
    }

    .operations-grid {
        grid-template-columns: 1fr;
    }
}
```

E, por fim, também na mesma pasta, crie o arquivo `script.js` com o seguinte conteúdo para implementar a lógica de interação com o RefeicaoController via fetch API do JavaScript:
```javascript
// -----------------------------
// CRUD Refeições (frontend)
// Controller: /<contexto>/refeicao/api
// -----------------------------

// Descobre o context path automaticamente.
// Ex.: /webapp/index.html  ->  /webapp
const _pathParts = window.location.pathname.split('/').filter(Boolean);
// Se estiver em contexto root (ex.: /index.html), não deve assumir que o primeiro "segmento" é o contexto.
const _first = _pathParts[0] || '';
const _contextPath = (
    _pathParts.length > 1 || (_first && !_first.includes('.'))
) ? `/${_first}` : '';

// Base absoluta para evitar problemas com subpastas.
const API_BASE = `${window.location.origin}${_contextPath}/refeicao/api`;

function escapeHtml(str) {
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

async function readResponseBody(response) {
    const contentType = (response.headers.get('content-type') || '').toLowerCase();
    const text = await response.text();

    if (!text) return null;

    // Preferir JSON quando o header indicar.
    if (contentType.includes('application/json')) {
        try {
            return JSON.parse(text);
        } catch {
            return text;
        }
    }

    // Muitos exemplos didáticos esquecem o content-type; tenta parsear mesmo assim.
    try {
        return JSON.parse(text);
    } catch {
        return text;
    }
}

function showResponse(elementId, body, statusCode) {
    const element = document.getElementById(elementId);
    const ok = statusCode >= 200 && statusCode < 300;
    const statusClass = ok ? 'success' : 'error';
    const statusBadge = ok ? 'status-success' : 'status-error';

    const printable = (typeof body === 'string')
        ? body
        : JSON.stringify(body, null, 2);

    element.className = `response-display ${statusClass}`;
    element.innerHTML = `
        <span class="status-code ${statusBadge}">${statusCode}</span>
        <span>${new Date().toLocaleTimeString()}</span>
        <hr style="margin: 10px 0; border: none; border-top: 1px solid #ccc;">
        <pre>${escapeHtml(printable)}</pre>
    `;
    element.style.display = 'block';

    updateLog(`[${statusCode}] ${elementId}`, body);
}

function updateLog(action, _response) {
    const logDisplay = document.getElementById('log-display');
    const timestamp = new Date().toLocaleTimeString();
    const logEntry = `<strong>[${timestamp}]</strong> ${escapeHtml(action)}<br>`;
    logDisplay.innerHTML = logEntry + logDisplay.innerHTML;
}

function getValue(id) {
    const el = document.getElementById(id);
    return (el?.value ?? '').trim();
}

function requireValue(id, label) {
    const v = getValue(id);
    if (!v) {
        alert(`Preencha o campo: ${label}`);
        throw new Error(`Campo obrigatório vazio: ${id}`);
    }
    return v;
}

function clearInput(...ids) {
    let last = null;
    ids.forEach(id => {
        const element = document.getElementById(id);
        if (element) {
            element.value = '';
            last = element;
        }
    });
    last?.focus();
}

// -----------------------------
// GET
// -----------------------------

async function fetchAll() {
    updateLog(`GET ${API_BASE} (all)`, null);
    try {
        const response = await fetch(API_BASE);
        const body = await readResponseBody(response);
        showResponse('getall-response', body, response.status);
    } catch (error) {
        showResponse('getall-response', { error: error.message }, 500);
    }
}

async function fetchByIdCartaoDataRefeicao() {
    try {
        const idCartaoEstudante = requireValue('getByBoth-idCartaoEstudante', 'idCartaoEstudante');
        const dataRefeicao = requireValue('getByBoth-dataRefeicao', 'dataRefeicao (YYYY-MM-DD)');

        const url = new URL(API_BASE);
        url.searchParams.set('idCartaoEstudante', idCartaoEstudante);
        url.searchParams.set('dataRefeicao', dataRefeicao);

        updateLog(`GET ${url.pathname}${url.search}`, null);
        const response = await fetch(url.toString());
        const body = await readResponseBody(response);
        showResponse('getByBoth-response', body, response.status);

    } catch (error) {
        // requireValue já alertou; mas se foi outra falha, mostra erro.
        if (error?.message?.startsWith('Campo obrigatório')) return;
        showResponse('getByBoth-response', { error: error.message }, 500);
    }
}

async function fetchByIdCartao() {
    try {
        const idCartaoEstudante = requireValue('getByCartao-idCartaoEstudante', 'idCartaoEstudante');

        const url = new URL(API_BASE);
        url.searchParams.set('idCartaoEstudante', idCartaoEstudante);

        updateLog(`GET ${url.pathname}${url.search}`, null);
        const response = await fetch(url.toString());
        const body = await readResponseBody(response);
        showResponse('getByCartao-response', body, response.status);

    } catch (error) {
        if (error?.message?.startsWith('Campo obrigatório')) return;
        showResponse('getByCartao-response', { error: error.message }, 500);
    }
}

async function fetchByDataRefeicao() {
    try {
        const dataRefeicao = requireValue('getByData-dataRefeicao', 'dataRefeicao (YYYY-MM-DD)');

        const url = new URL(API_BASE);
        url.searchParams.set('dataRefeicao', dataRefeicao);

        updateLog(`GET ${url.pathname}${url.search}`, null);
        const response = await fetch(url.toString());
        const body = await readResponseBody(response);
        showResponse('getByData-response', body, response.status);

    } catch (error) {
        if (error?.message?.startsWith('Campo obrigatório')) return;
        showResponse('getByData-response', { error: error.message }, 500);
    }
}

// -----------------------------
// POST
// -----------------------------

async function createRecord() {
    try {
        const idCartaoEstudante = requireValue('post-idCartaoEstudante', 'idCartaoEstudante');
        const dataRefeicao = requireValue('post-dataRefeicao', 'dataRefeicao (YYYY-MM-DD)');

        updateLog(`POST ${API_BASE} (create)`, null);

        const params = new URLSearchParams({
            idCartaoEstudante,
            dataRefeicao,
        });

        const response = await fetch(API_BASE, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: params.toString(),
        });

        const body = await readResponseBody(response);
        showResponse('post-response', body, response.status);

        if (response.ok) {
            clearInput('post-idCartaoEstudante', 'post-dataRefeicao');
        }

    } catch (error) {
        if (error?.message?.startsWith('Campo obrigatório')) return;
        showResponse('post-response', { error: error.message }, 500);
    }
}

// -----------------------------
// PUT
// -----------------------------

async function updateRecord() {
    try {
        const oldIdCartaoEstudante = requireValue('put-oldIdCartaoEstudante', 'oldIdCartaoEstudante');
        const oldDataRefeicao = requireValue('put-oldDataRefeicao', 'oldDataRefeicao (YYYY-MM-DD)');
        const newIdCartaoEstudante = requireValue('put-newIdCartaoEstudante', 'newIdCartaoEstudante');
        const newDataRefeicao = requireValue('put-newDataRefeicao', 'newDataRefeicao (YYYY-MM-DD)');

        // Importante: em Tomcat é comum PUT com body form-urlencoded não preencher getParameter().
        // Por isso enviamos os parâmetros na query string.
        const url = new URL(API_BASE);
        url.searchParams.set('oldIdCartaoEstudante', oldIdCartaoEstudante);
        url.searchParams.set('oldDataRefeicao', oldDataRefeicao);
        url.searchParams.set('newIdCartaoEstudante', newIdCartaoEstudante);
        url.searchParams.set('newDataRefeicao', newDataRefeicao);

        updateLog(`PUT ${url.pathname}${url.search}`, null);

        const response = await fetch(url.toString(), {
            method: 'PUT'
        });

        const body = await readResponseBody(response);
        showResponse('put-response', body, response.status);

        if (response.ok) {
            clearInput('put-oldIdCartaoEstudante', 'put-oldDataRefeicao', 'put-newIdCartaoEstudante', 'put-newDataRefeicao');
        }

    } catch (error) {
        if (error?.message?.startsWith('Campo obrigatório')) return;
        showResponse('put-response', { error: error.message }, 500);
    }
}

// -----------------------------
// DELETE
// -----------------------------

async function deleteRecord() {
    try {
        const idCartaoEstudante = requireValue('delete-idCartaoEstudante', 'idCartaoEstudante');
        const dataRefeicao = requireValue('delete-dataRefeicao', 'dataRefeicao (YYYY-MM-DD)');

        // Mesmo motivo do PUT: usar query string.
        const url = new URL(API_BASE);
        url.searchParams.set('idCartaoEstudante', idCartaoEstudante);
        url.searchParams.set('dataRefeicao', dataRefeicao);

        updateLog(`DELETE ${url.pathname}${url.search}`, null);

        const response = await fetch(url.toString(), {
            method: 'DELETE'
        });

        const body = await readResponseBody(response);
        showResponse('delete-response', body, response.status);

        if (response.ok) {
            clearInput('delete-idCartaoEstudante', 'delete-dataRefeicao');
        }

    } catch (error) {
        if (error?.message?.startsWith('Campo obrigatório')) return;
        showResponse('delete-response', { error: error.message }, 500);
    }
}

// -----------------------------
// UX: Enter para submeter
// -----------------------------

document.addEventListener('keypress', (e) => {
    if (e.key !== 'Enter') return;

    const id = e.target?.id;
    if (!id) return;

    // GET
    if (id === 'getByBoth-dataRefeicao' || id === 'getByBoth-idCartaoEstudante') {
        fetchByIdCartaoDataRefeicao();
        return;
    }
    if (id === 'getByCartao-idCartaoEstudante') {
        fetchByIdCartao();
        return;
    }
    if (id === 'getByData-dataRefeicao') {
        fetchByDataRefeicao();
        return;
    }

    // POST
    if (id === 'post-dataRefeicao' || id === 'post-idCartaoEstudante') {
        createRecord();
        return;
    }

    // PUT
    if (id.startsWith('put-')) {
        updateRecord();
        return;
    }

    // DELETE
    if (id.startsWith('delete-')) {
        deleteRecord();
        return;
    }
});
```

Pronto, agora, ao acessar a URL [http://localhost:8080/webapp/refeicao](http://localhost:8080/webapp/refeicao), você verá a interface de CRUD de Refeições, permitindo criar, ler, atualizar e deletar refeições de forma amigável.

Se você acessar apenas [http://localhost:8080/webapp/](http://localhost:8080/webapp/), verá a welcome page da aplicação webapp, com link apenas para a view de BasicModel. Adicione um link para a view de Refeição, abaixo do link já existente, editando o arquivo `src/main/webapp/index.html`:

```html
    <br>
    <a href="/webapp/refeicao">Go to Refeição Model CRUD Operations</a>
```

<script>
    document.querySelectorAll('pre > code').forEach(code => {
      const pre = code.parentElement;
      const btn = document.createElement('button');
      btn.className = 'copy-btn';
      btn.type = 'button';
      btn.textContent = 'Copy';
      btn.addEventListener('click', async () => {
        const text = code.innerText;
        try {
          await navigator.clipboard.writeText(text);
          btn.textContent = 'Copied!';
        } catch {
          const ta = document.createElement('textarea');
          ta.value = text; document.body.appendChild(ta);
          ta.select(); document.execCommand('copy');
          document.body.removeChild(ta);
          btn.textContent = 'Copied!';
        }
        setTimeout(() => (btn.textContent = 'Copy'), 1500);
      });
      pre.appendChild(btn);
    });

    // Syntax highlight
    hljs.highlightAll();
</script>
