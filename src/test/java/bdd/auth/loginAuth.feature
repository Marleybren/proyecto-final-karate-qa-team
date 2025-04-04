Feature: Casos de Prueba de LOGIN
  Background:
    * url urlBase
    * path "/api/login"

  @login_OK
  Scenario: CP01 - Validar LOGIN con credenciales correctas
    * def body = read('classpath:resources/json/auth/bodyLogin.json')

    And request body
    When method post
    Then status 200
    * def token_auth = response.access_token
    * print response
    # El simbolo $ es igual a response cuando utilizamos "match"
    And match responseType == "json"
    And match $.user.email == body.email
    And match $.message == "Hi"+ response.user.nombre
    And match $ ==
    """
    {
        "message": '#string? _.length >= 0',
        "access_token": '#string? _.length >= 0',
        "token_type": '#string? _.length >= 0',
        "user":
        {
          "id": '#number',
          "nombre": '#string? _.length >= 0',
          "email": '#string? _.length >= 0',
          "password": '#string? _.length >= 0',
          "estado": '#number',
          "tipo_usuario_id": '#number',
          "created_at": '#string',
          "updated_at": '#string'
        }
    }
    """
    #Otra manera de validar el tipo de dato
    #And match $.user == {"id":#number,"nombre":#string,"email":#string,"password":#string,"estado":#number,"tipo_usuario_id":#number,"created_at":#string,"updated_at":#string}

  @login_NOOK
  Scenario: CP02 - Validar LOGIN con credenciales incorrectas
    * def body =
    """
    {
      "email": "rossmery274xyz@gmail.com",
      "password": "12345678"
     }
    """
    And request body
    When method post
    Then status 401
    * def token_auth = response.access_token
    * print response
    # El simbolo $ es igual a response cuando utilizamos "match"
    And match responseType == "json"
    And match $ == {"message":#string}
    And match $.message == "Datos incorrectos"


