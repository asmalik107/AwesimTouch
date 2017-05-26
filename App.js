import React, {Component} from 'react';
import {Alert, AppState, Button, NativeModules, StyleSheet, Text, View} from 'react-native';
const KeychainManager = NativeModules.KeychainManager;

//console.log('HERE', KeychainManager);

KeychainManager.test();

class App extends Component {

  constructor(props) {
    super(props);

    this.state = {
      appState: AppState.currentState,
      error: '',
      available: 'FALSE',
      password: ''
    };
  }

  alert(){
    Alert.alert(
      'Alert',
      '',
      [
        {text: 'OK', onPress: () => console.log('OK Pressed!')},
      ]
    );
  }

  componentDidMount() {
    AppState.addEventListener('change', this._handleAppStateChange);

    KeychainManager.isAvailable((error, result) => {

      console.log('HERE');
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

  componentWillUnmount() {
    AppState.removeEventListener('change', this._handleAppStateChange);
  }

  _handleAppStateChange = (nextAppState) => {

    console.log('NEXT_APP_STATE', nextAppState);
    if (this.state.appState.match(/background/) && nextAppState === 'active') {
      console.log('APP_STATE', 'App has come to the foreground!');
      //this.alert();
      this.getKey();
    }
    this.setState({appState: nextAppState});

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
          AppState: {this.state.appState}
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

export default App;