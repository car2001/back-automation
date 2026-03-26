Feature: POST usuarios

  Background:
    * def random = java.util.UUID.randomUUID() + ''
    * def uniqueEmail = 'qa_' + random + '@mail.com'
    * def uniqueName = 'Usuario QA ' + random

  Scenario: Registrar nuevo usuario con datos válidos
    Given url baseUrl
    And path 'usuarios'
    And request
    """
    {
      "nome": "#(uniqueName)",
      "email": "#(uniqueEmail)",
      "password": "Test1234",
      "administrador": "true"
    }
    """
    When method post
    Then status 201
    And match response == read('classpath:schemas/create-user-response-schema.json')
    And match response.message == 'Cadastro realizado com sucesso'

  Scenario: No permitir registrar usuario con email duplicado
    * def duplicatedEmail = 'duplicado_' + random + '@mail.com'
    * def firstPayload =
    """
    {
      "nome": "Primer Usuario",
      "email": "#(duplicatedEmail)",
      "password": "Test1234",
      "administrador": "true"
    }
    """
    * def secondPayload =
    """
    {
      "nome": "Segundo Usuario",
      "email": "#(duplicatedEmail)",
      "password": "Test1234",
      "administrador": "false"
    }
    """

    Given url baseUrl
    And path 'usuarios'
    And request firstPayload
    When method post
    Then status 201

    Given url baseUrl
    And path 'usuarios'
    And request secondPayload
    When method post
    Then status 400
    And match response.message == 'Este email já está sendo usado'


  Scenario: No permitir registrar usuario sin email
    Given url baseUrl
    And path 'usuarios'
    And request { nome: 'Test', password: '1234', administrador: 'true' }
    When method post
    Then status 400