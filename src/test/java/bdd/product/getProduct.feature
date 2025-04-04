Feature: Casos de Prueba sobre Obtener Productos

  Background:
    * def responseLogin = call read('classpath:bdd/auth/loginAuth.feature@login_OK')
    * print responseLogin
    * def tokenAuth = responseLogin.token_auth
    * print tokenAuth
    * url urlBase
    * header Accept = 'application/json'
    * header Authorization = 'Bearer ' + tokenAuth

    @Consulta_OK
  Scenario: CP01 - Obtener datos de un producto especifico
    * def id = 497
    And path "/api/v1/producto/" + id
    When method get
    Then status 200
    * print response
    And match responseType == "json"
    And match $.id == id
    And match $..estado contains '#notnull'
    And match $..nombre contains 'BGM Producto'
    #And assert response.codigo.length == 6
    And match response.codigo == '#? _.length == 6'

  @Consulta_NOOK
  Scenario: CP02 - Consultar un id no existente
    * def id = 999
    And path "/api/v1/producto/" + id
    When method get
    Then status 404
    * print response
    # El simbolo $ es igual a response cuando utilizamos "match"
    And match responseType == "json"
    And match $.error == "Producto no encontrado"
    And match $.error contains '#notnull'
