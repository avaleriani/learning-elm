import React, { Component } from 'react';
import Elm from './ImageUpload.elm';
import './ImageUpload.css';

class ImageUpload extends Component {
  constructor(props) {
    super(props);
    this.setElmRef = this.setElmRef.bind(this);
  }

  componentDidMount() {
    console.log(Elm, Elm.ImageUpload)
    this.elm = Elm.ImageUpload.embed(this.elmRef);
    this.elm.ports.uploadImages.subscribe(this.readImages);
  }

  setElmRef(node) {
    this.elmRef = node;
  }

  render() {
    return <div ref={this.setElmRef} />;
  }
}

export default ImageUpload;