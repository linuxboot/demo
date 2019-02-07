package main

import "fmt"

var banner = ("            _       _           _        _ _           \n" +
	" _ __   ___| |_    (_)_ __  ___| |_ __ _| | | ___ _ __ \n" +
	"| '_ \\ / _ \\ __|   | | '_ \\/ __| __/ _` | | |/ _ \\ '__|\n" +
	"| | | |  __/ |_    | | | | \\__ \\ || (_| | | |  __/ |   \n" +
	"|_| |_|\\___|\\__|   |_|_| |_|___/\\__\\__,_|_|_|\\___|_|   \n")

func main() {
	fmt.Println(banner)
	fmt.Println("I am not really a net installer, I'm here just to prove the point.")
	fmt.Println()
}
