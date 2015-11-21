#= require bootstrap/affix

generateSidebar = ->
	menu = []
	generate = (arr, heading) ->
		submenu = []
		unless heading.attr('id')
			newId = heading.text().toLowerCase().replace(/\s+/g, '-').replace(':', '')
			newId = newId + '-'  while $(newId).length > 0
			console.log newId
			heading.attr 'id', newId
		heading.next('.wrap').children('h3').each ->
			generate submenu, $(this)
		arr.push {
			heading: heading
			menu: submenu
		}

	headings = $('#main-col').find('h2')
	headings.each ->
		$this = $(this)
		generate menu, $this

	createHtml = (arr) ->
		a = []
		a.push '<ul class="nav nav-stacked">'
		for item in arr
			a.push '<li>'
			a.push '<a href="#' + item.heading.attr('id') + '">' + item.heading.text() + '</a>'
			a.push createHtml item.menu  if item.menu.length > 0
			a.push '</li>'
		a.push '</ul>'
		a.join('')

	sidebar = $('.docs-sidebar', '#aside-col')
	sidebar.html createHtml menu

	sidebar.affix()

	sidebar.on 'click', 'a', (e) ->
		e.preventDefault()
		$('html, body').animate
			scrollTop: $($(this).attr('href')).offset().top - 70

initExamples = ->
	lengths = []
	current = []
	examples = $('.example-wrap')
	examples.each ->
		$this = $(this)
		a = $this.find('.example > div').length
		$this.addClass "steps-#{ a }"
		if lengths.indexOf(a) is -1
			lengths.push a
			current.push 0

	$body = $('body')
	setIndices = ->
		for len, index in lengths
			current[index] = current[index]+1
			current[index] = 0  if current[index] > len
			$body.removeClass (index, css) ->
				a = css.match(/steps-2-\d+/g) or []
				a.join(' ')
			$body.addClass("steps-#{ len }-#{ current[index] }")

	setIndices()
	setInterval (->
		setIndices()
	), 1000

$ ->
	generateSidebar()
	initExamples()
