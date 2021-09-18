package main

import "fmt"

func main() {
	a := 5
	b := 2
	fmt.Println(a / b)

	var c int
	fmt.Scanf("%d", &c)
	fmt.Println(a / c)

	var d int
	fmt.Scanf("%d", &d)
	if d == 0 {
		return
	}
	fmt.Println(a / d)

	e := 0
	fmt.Println(a / e)
}
