import Variation from '../../data/variation.js'
import Funnel from './models/funnel.js'
import Messages from './views/messages.js'
import Ui from './views/ui.js'

export default function Allthread() {
  const variations = new Variation
  const funnel = new Funnel(variations)
  const messages = new Messages
  var form = document.querySelectorAll('form')[0]
  var text = document.querySelector('.text')
  var images = document.querySelector('.images')
  var inputs = document.querySelector('.inputs')
  var button = document.getElementById('continueButton')
  const ui = new Ui(text, images, inputs, button, funnel, messages, form)
}

