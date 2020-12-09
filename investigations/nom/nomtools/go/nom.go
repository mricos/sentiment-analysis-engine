package main

import (
    "encoding/json"
    "fmt"
    "os"
	"io/ioutil"
)

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func main() {
	fmt.Printf("Go Version of Nodeholder Object Model, 000g1\n")
	fmt.Print("https://golang.org/doc/code.html")

    const filePath="data.json"
	jsonFile, err := os.Open(filePath)
	check(err)
	fmt.Print("Using file" + filePath)

    //byt := []byte(`{"num":6.13,"strs":["a","b"]}`)
	var dat map[string]interface{}

    //if err := json.Unmarshal(byt, &dat); err != nil {
	//    panic(err)
	// }
	// fmt.Println(dat)

	bytes, _ := ioutil.ReadAll(jsonFile)
	// TODO:https://golang.org/pkg/encoding/json/#Unmarshal 
	//fmt.Printf("Data: "+ json[0].data[0] +"\n")
	fmt.Printf("byteValue: " + string(bytes[:])  + "\n")
	fmt.Println("Trying unmarshall on data")
    if err := json.Unmarshal(bytes, &dat); err != nil {
        panic(err)
    }
    fmt.Println(dat)
}

/*
https://golang.org/pkg/encoding/json/#Unmarshal 
https://gobyexample.com/reading-files
*/
