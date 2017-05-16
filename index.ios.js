/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component} from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View
} from 'react-native';
import {NativeModules} from 'react-native';
const KeychainManager = NativeModules.KeychainManager;
//console.log('HERE', KeychainManager);

KeychainManager.test();


export default class AwesimTouch extends Component {

  constructor(props) {
    super(props);

    this.state = {p: ''};
  }

  getKey() {
    return KeychainManager.getItem('myKey')
      .then(p => {
        console.log('Password', p);

        this.setState({p});

        //KeychainManager.delete('myKey');
      });
  }

  componentDidMount() {
    KeychainManager.save('myKey', 'Some text')
      .then(this.getKey)
      .catch(e => {
      console.log(e)
    });
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Password: {this.state.p}
        </Text>
        {/*       <Text style={styles.instructions}>
         To get started, edit index.ios.js
         </Text>
         <Text style={styles.instructions}>
         Press Cmd+R to reload,{'\n'}
         Cmd+D or shake for dev menu
         </Text>*/}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('AwesimTouch', () => AwesimTouch);
