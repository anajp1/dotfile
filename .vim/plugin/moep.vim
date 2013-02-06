function! Moep()
	"let moepi = "pipipi no pi"
	let moepi = execute ":normal :set=enc?"
	call cursor( 1, col("$"))
	execute ":normal a" . moepi . "dayo~!!"
endfunction

command! Moep call Moep()
