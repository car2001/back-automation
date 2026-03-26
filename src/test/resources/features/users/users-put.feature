Feature: PUT usuarios

  Background:
    * def random = java.util.UUID.randomUUID() + ''
    * def emailCreate = 'qa_put_create_' + random + '@mail.com'
    * def emailUpdate = 'qa_put_update_' + random + '@mail.com'

  Scenario: Actualizar información de un usuario existente
    Given url baseUrl
    And path 'usuarios'
    And request
    """
    {
      "nome": "Usuario Inicial",
      "email": "#(emailCreate)",
      "password": "Test1234",
      "administrador": "true"
    }
    """
    When method post
    Then status 201
    And def userId = response._id

    Given url baseUrl
    And path 'usuarios', userId
    And request
    """
    {
      "nome": "Usuario Actualizado",
      "email": "#(emailUpdate)",
      "password": "NuevaClave123",
      "administrador": "false"
    }
    """
    When method put
    Then status 200
    And match response.message == 'Registro alterado com sucesso'

    Given url baseUrl
    And path 'usuarios', userId
    When method get
    Then status 200
    And match response.nome == 'Usuario Actualizado'
    And match response.email == emailUpdate
    And match response.administrador == 'false'