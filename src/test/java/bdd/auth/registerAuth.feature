Feature: Casos de Prueba de Registro de Usuario
  Background:
    * url urlBase
    * path "/api/register"

  @registro_OK
  Scenario Outline: CP01 - Validar registro de usuarios
    * def body =
    """
    {
      "email": "<email>",
      "password": "<pass>",
      "nombre": "<nombre>",
      "tipo_usuario_id": <tipo>,
      "estado": <estado>
     }
    """
    And request body
    When method post
    Then status 200
    * print response
    # El simbolo $ es igual a response cuando utilizamos "match"
    And match responseType == "json"
    And match $.data.email == body.email
    And match $.data.nombre == body.nombre
    And match $.data.estado == body.estado
    And match $..id contains '#notnull'
    #And match $..nombre contains 'Pepe'
    And match $.data.tipo_usuario_id == body.tipo_usuario_id
    And match $ ==
    """
    {
        "data":
        {
          "nombre": '#string? _.length >= 0',
          "email": '#string? _.length >= 0',
          "password": '#string? _.length >= 0',
          "estado": '#number',
          "tipo_usuario_id": '#number',
          "updated_at": '#string',
          "created_at": '#string',
          "id": '#number'
        },
        "access_token": '#string? _.length >= 0',
        "token_type": '#string? _.length >= 0'
    }
    """
    Examples:
    |read ('classpath:resources/csv/auth/dataRegistro.csv')|
    #|email|pass|nombre|tipo|estado|
    #|prueba0.4@gmail.com|12345678|Pepe|1    |1      |
    #|prueba2@gmail.com|12345678|Pepe|1    |1      |
    #|prueba3@gmail.com|12345678|Pepe|1    |1      |
    #|prueba4@gmail.com|12345678|Pepe|1    |1      |

  @registro_NOOK
  Scenario: CP02 - Validar mensaje al registrar usuario existente
    * def body =
    """
    {
      "email": "rossmery274@gmail.com",
      "password": "12345678",
      "nombre": "Brenda",
      "tipo_usuario_id": 1,
      "estado": 1
     }
    """
    And request body
    When method post
    Then status 500
    * print response
    # El simbolo $ es igual a response cuando utilizamos "match"
    And match responseType == "json"
    And match $.email[0] == "The email has already been taken."
    And match $..email[0] contains '#notnull'


