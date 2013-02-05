$(document).ready () ->
  $('.nameInput').on "keyup", (event) ->
    if event.keyCode == 13
      scraper = makeScraper()
      scraper.getRelatedPeople(event.target.value)
    

