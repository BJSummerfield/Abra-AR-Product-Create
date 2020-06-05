import Allthread from './allthread/allthread.js'
import Single from './single/single.js'

const param = new URL(document.location).searchParams.get('type')
if (param =='atr') {
  Allthread()
} else if (param == 'ser') {
  Single()
}