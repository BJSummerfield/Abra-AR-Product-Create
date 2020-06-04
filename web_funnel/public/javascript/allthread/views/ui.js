class Ui {
  constructor(text, images, inputs, button, funnel, messages, form) {
  this.text = text
  this.images = images
  this.inputs = inputs
  this.button = button
  this.funnel = funnel
  this.messages = messages
  this.form = form
  this.step = 0
  this.flow_step = ['type', 'grade', 'finish', 'diameter', 'length']
  this.runFunnel()
  }

  runFunnel() {
    this.createForm(this.form)
    this.createText(this.messages.welcome, this.text)
    this.generateImage(this.images, 'public/data/images/abrafast.png')
    this.addListeners()
  }

  createForm(form) {
    this.flow_step.forEach(function(element){
      var input = document.createElement('input')
      input.type = 'hidden'
      input.name = element
      form.appendChild(input)
    })
    form['type'].value = 'all threaded rod'
  }

  selectFinish() {
    this.removeElements()
    this.createText(this.messages.finish, this.text)
    this.generateInput(this.funnel.variations['finishes'], this.inputs)
    this.generateImage(this.images, 'public/data/images/finish.jpg')
  }

  selectGrade() {
    this.removeElements()
    this.createText(this.messages.grade, this.text)
    this.generateInput(this.funnel.variations['grades'], this.inputs)
    this.generateImage(this.images, 'public/data/images/grade.jpg')
  }

  selectDiameter() {
    this.removeElements()
    this.createText(this.messages.diameter, this.text)
    this.generateInput(this.funnel.variations['diameters'], this.inputs)
    this.generateImage(this.images, 'public/data/images/diameter.jpg')
  }

  selectLength(error) {
    this.removeElements()
    this.createText(this.messages.length, this.text)
    var selectGrid = document.createElement('div')
    selectGrid.classList.add("selectGrid")
    this.createSelectGrid(this.messages.lengths, selectGrid)
    this.inputs.appendChild(selectGrid)
    this.addSelectListener(document.getElementById('Feet'))
    this.generateImage(this.images, 'public/data/images/length.jpg')
  }

  removeElements() {
      this.removeChildren(this.inputs)
      this.removeChildren(this.text)
      this.removeChildren(this.images)

  }

  createSelectGrid(message_array, node) {
    for (var i = 0; i < message_array.length; i++) {
      var textNode = this.createText(message_array[i])
      var text = this.createLengthText(this.funnel.variations['lengths'][i], i)
      this.generateLengths(this.funnel.variations['lengths'][i], textNode, text, message_array[i])
      node.appendChild(textNode)
    }
  }

  addSelectListener(node) {
    var inches = document.getElementById('Inches')
    var subInches = document.getElementById('Sub-Inches')
    node.addEventListener('change', (e) => {
      if (e.target.value == 288) {
        inches.disabled = true
        inches.value = 0
        subInches.disabled = true
        subInches.value = 0
      } else {
        inches.disabled = false
        subInches.disabled = false
      }
    })
  }

  createLengthText(array, i) {
    var return_array = []
    array.forEach(function(number){
      if (i === 1){
        return_array.push(`${parseInt(number) / 4}"`)
      } 
      if (i === 0){
        return_array.push(`${(parseInt(number) / 4) / 12}'`)
      }
      if (i === 2) {
        return_array.push(`${parseInt(number) / 4}"`)
      }
    
    })
    return return_array
  }

  generateImage(node, src) {
    var imageNode = document.createElement('img')
    imageNode.src = src
    node.appendChild(imageNode)
  }

  generateLengths(variations, inputNode, text, unit) {
    var i = 0
    var selectNode = document.createElement('select')
    selectNode.id = unit.replace(":", "")
    variations.forEach(function(variation){
      var optionNode = document.createElement('option')
      optionNode.innerText = text[i]
      optionNode.value = variation
      selectNode.appendChild(optionNode)
      i++
    })
    inputNode.appendChild(selectNode)
  }

  generateInput(variations, inputNode) {
    var selectNode = document.createElement('select')
    variations.forEach(function(variation){
      var optionNode = document.createElement('option')
      optionNode.innerText = variation
      optionNode.value = variation
      selectNode.appendChild(optionNode)
    })
    inputNode.appendChild(selectNode)
  }

  removeChildren(node) {
    while (node.firstChild) {
      node.removeChild(node.lastChild);
    }
  }
  
  createText(message, parent = null) {
    var node = document.createElement('div')
    node.innerText = message
    if (parent == null){
      return node
    } else {
      parent.appendChild(node)
    }
  }

  updateParams() {
    var selectOptions = document.getElementsByTagName('select')
    var item = 0
    for (var i = 0; i < selectOptions.length; i++) {
      if (isNaN(selectOptions[i].value) == true) {
        item = selectOptions[i].value
      }
      if (isNaN(selectOptions[i].value) == false) {
        item += parseInt(selectOptions[i].value)
      }
    }
    var input = document.querySelector(`[name=${this.flow_step[this.step]}`)
    input.value = item.toString().toLowerCase()
  }

  makeHref(params) {
    var string = ""
    string += params[0].split(" ").reduce((memo, word) =>
      memo += word.slice(0,1).toUpperCase(), "")
    string += "-"
    string += params[1].replace(" Grade ", "-")
    string += params[2].split(" ").reduce((memo, word) =>
      memo += word.slice(0,1).toUpperCase(), "")
    string += "-"
    string += params[3].replace('/',"").replace('"',"")
    string += "-"
    string += params[4].toString()
    return string
  }

  checkMinimumLength() {
    if (this.step == 4 && parseInt(this.form['length'].value) < 24) {
      this.step = 4
      this.removeChildren(this.button)
      this.selectLength()
      this.createError('Please Select a Length Greater than 6"')
    }
  }

  createError(error) {
    var node = document.createElement('div')
    node.innerText = error
    this.button.appendChild(node)
  }

  funnelStep() {
    if (this.step == 0) {
      this.selectGrade()
    }
    if (this.step != 0) {
      this.updateParams()
      this.checkMinimumLength()
      if (this.step == 1) {
        this.selectFinish()
      } 
      if (this.step == 2) {
        this.selectDiameter()
      }           
      if (this.step == 3) {
        this.selectLength()
      }
      if (this.step == 4) {
        this.form.submit()
      }
    }     
    this.step++
  }

  addListeners(){
    this.button.addEventListener('click', () =>{
      this.funnelStep()
    })
  }
}
export default Ui
