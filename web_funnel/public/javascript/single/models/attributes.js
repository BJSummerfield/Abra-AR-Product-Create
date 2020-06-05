class Attributes {
  constructor(variation) { 
    this.variations = {}
    this.setVariations(variation)
  }

  setVariations(variation){
    this.lengths = []
    this.lengths.push(this.createLengths(288, 48)) //Feet
    this.lengths.push(this.createLengths(44, 4)) // Inches
    this.lengths.push(this.createLengths(3, 1)) // 1/4 Inch
    this.threads = []
    this.variations['types'] = variation.types
    this.variations['grades'] = variation.grades
    this.variations['finishes'] = variation.finishes
    this.variations['diameters'] = variation.diameters
    this.variations['lengths'] = this.lengths
    this.variations['threads'] = this.threads

  }

  createLengths(max, increase_value) {
    var array = [] 
    for (var i = 0; i <= max; i += increase_value) {
      array.push(i)
    }
    return array
  }
}

export default Attributes