require ["findBirth", "graph", "typeAhead", "getPerson"], (findBirth, graph, typeAhead, getPerson) ->

  $(document).ready () ->
    typeAhead.attachWikiAutoComplete ".nameInput"

    $('.nameInput').on "keyup", (event) ->
      if event.keyCode == 13
        $('.findBirthDate').click()

    $('.findBirthDate').on "click", (event) ->
      $("body").addClass("hideBackGround")
      searchName = $(".nameInput").val()
      getPerson.getPerson(searchName)

    $('#whoIsButton').on "click", (event) ->
      $('#bioDisplay').addClass("bioShow")
      $('#bioDisplay').removeClass("bioHide")

    $('#whoIsClose').on "click", (event) ->
      $('#bioDisplay').addClass("bioHide")
      $('#bioDisplay').removeClass("bioShow")
