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
import {Button, NativeModules} from 'react-native';
const KeychainManager = NativeModules.KeychainManager;
//console.log('HERE', KeychainManager);

KeychainManager.test();


export default class AwesimTouch extends Component {

  constructor(props) {
    super(props);

    this.state = {
      error: '',
      available: 'FALSE',
      password: ''
    };
  }

  getKey = () => {
    return KeychainManager.getItem('myKey', (error, value) => {
      if (error) {
        console.log('ERROR', error);
        this.setState({error: error});
      } else {
        console.log('Get', value);
        this.setState({password: value});
      }
    });
  }

  componentDidMount() {
    KeychainManager.isAvailable((error, result) => {

      console.log('HERE')
      if (error) {
        console.log('ERROR', error);
        this.setState({error: error});
      } else {
        console.log('AVAILABLE', result);
        this.setState({available: result ? 'TRUE' : 'FALSE'});
      }
    });


    KeychainManager.save('myKey', 'Some text', (error) => {
      if (error) {
        console.log('ERROR', error);
        this.setState({error: error});
      } else {
        console.log('Save');
        this.getKey();
      }
    });
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Supported: {this.state.available}
        </Text>
        <Text style={styles.welcome}>
          Password: {this.state.password}
        </Text>
        <Text style={styles.welcome}>
          Error: {this.state.error.message}
        </Text>
        <Button
          title="Get Item"
          onPress={this.getKey}
          color="#841584"
        />
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
