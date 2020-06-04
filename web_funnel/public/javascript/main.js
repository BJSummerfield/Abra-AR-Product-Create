import Allthread from './allthread/allthread.js'

const param = new URL(document.location).searchParams.get('type')
if (param =='atr') {
  Allthread()
} else if (param == 'ser') {
  
}