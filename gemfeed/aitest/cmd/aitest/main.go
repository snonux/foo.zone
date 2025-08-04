package main

import (
	"flag"
	"fmt"
	"os"

	"aitest/internal"
)

func main() {
	var versionFlag bool
	flag.BoolVar(&versionFlag, "v", false, "print version")
	dir := flag.String("dir", "", "directory to count files in")
	flag.Parse()

	if versionFlag {
		fmt.Println(internal.GetVersion())
		return
	}

	if *dir != "" {
		fileCount, err := internal.CountFiles(*dir)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error counting files: %v\n", err)
			os.Exit(1)
		}
		fmt.Printf("Number of files in directory %s: %d\n", *dir, fileCount)
	} else {
		fmt.Println("No directory specified. No count given.")
	}
}
