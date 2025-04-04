Feature: Casos de Prueba sobre Registro de Productos

  Background:
    * def responseLogin = call read('classpath:bdd/auth/loginAuth.feature@login_OK')
    * print responseLogin
    * def tokenAuth = responseLogin.token_auth
    * print tokenAuth
    * url urlBase
    * header Accept = 'application/json'
    * header Authorization = 'Bearer ' + tokenAuth

  @RegUndProducto_OK
  Scenario: CP01 - Registrar un nuevo producto
    * def body =
        """
        {
            "codigo": "BGM002",
            "nombre": "PRODUCTO BGM",
            "medida": "UND ",
            "marca": "Generico",
            "categoria": "Repuestos",
            "precio": "35.00",
            "stock": "48",
            "estado": "3",
            "descripcion": "Descripcion BGM PL200NS"
        }
        """
    And path "/api/v1/producto"
    And request body
    When method post
    Then status 200
    * print response
    And match responseType == "json"
    And match $..id contains '#notnull'
    And match $..updated_at contains '#notnull'
    And match $..created_at contains '#notnull'
    And match $..codigo contains body.codigo
    And match response.codigo == '#? _.length == 6'

  @RegProductos_OK
  Scenario Outline: CP02 - Registrar varios productos
    * def body =
    """
    {
            "codigo": <codigo>,
            "nombre": <nombre>,
            "medida": <medida>,
            "marca": <marca>,
            "categoria": <categoria>,
            "precio": <precio>,
            "stock": <stock>,
            "estado": <estado>,
            "descripcion": <descripcion>
     }
    """
    And path "/api/v1/producto"
    And request body
    When method post
    Then status 200
    * print response
    And match responseType == "json"
    And match $..id contains '#notnull'
    And match $..updated_at contains '#notnull'
    And match $..created_at contains '#notnull'
    And match $ ==
    """
    {
            "codigo":  '#string? _.length >= 0',
            "nombre":  '#string? _.length >= 0',
            "medida":  '#string? _.length >= 0',
            "marca_id":  '#number',
            "categoria_id":  '#number',
            "precio": '#number',
            "stock": '#number',
            "estado": '#number',
            "descripcion": '#string? _.length >= 0',
            "updated_at": '#string? _.length >= 0',
            "created_at": '#string? _.length >= 0',
            "id": '#number'


    }
    """
    Examples:
      |read ('classpath:resources/csv/producto/dataRegistro.csv')|

  @RegProducto_NOOK_Prodex
  Scenario: CP03 - Registrar un producto existente
    * def body =
        """
        {
            "codigo": "BGM002",
            "nombre": "PRODUCTO BGM",
            "medida": "UND ",
            "marca": "Generico",
            "categoria": "Repuestos",
            "precio": "35.00",
            "stock": "48",
            "estado": "3",
            "descripcion": "Descripcion BGM PL200NS"
        }
        """
    And path "/api/v1/producto"
    And request body
    When method post
    Then status 500
    * print response
    And match responseType == "json"
    And match $ == {"error":#string}

  @RegProducto_NOOK_EstInc
  Scenario: CP03 - Registrar un producto con tipo de dato incorrecto (estado)
    * def body =
        """
        {
            "codigo": "BGM002",
            "nombre": "PRODUCTO BGM",
            "medida": "UND ",
            "marca": "Generico",
            "categoria": "Repuestos",
            "precio": "35.00",
            "stock": "48",
            "estado": "PRUEBA",
            "descripcion": "Descripcion BGM PL200NS"
        }
        """
    And path "/api/v1/producto"
    And request body
    When method post
    Then status 500
    * print response
    And match responseType == "json"
    And match $.estado[0] == "The estado must be an integer."
    And match $..estado[0] contains '#notnull'