module.exports = class ModalWindow
  constructor: (@title = "", @content = "", @style={}, @forcing = false)->
  $modal = $("#modal-window")

  @isShowing: ->
    $modal.hasClass "show"

  show: ()->
    unless ModalWindow.isShowing()
      $modal.removeClass "forcing"
      $("#modal-overray").off()
      if @forcing
        $modal.addClass "forcing"
      $("#modal-window .content").html @content
      $("#modal-window>header .title").html @title
      $modal.css @style
      ModalWindow.centering()
      $modal.addClass "show"
      $("#modal-window:not(.forcing)+#modal-overray").on "click", ->
        $("#modal-window").removeClass "show"

  @centering: ()->
    $window = $ window
    top = (($window.height() - $modal.height()) / 2)
    left = (($window.width() - $modal.width()) / 2)
    $modal.css
      top: top
      left: left

$ ->
  $(window).on "resize", ->
    ModalWindow.centering()
