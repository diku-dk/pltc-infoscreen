(* Based on code by Torben Mogensen. *)

val rnd0 = Random.newgen ()
val seed0 = ref 0.0
val seed1 = ref 0.0

fun out s = TextIO.output (TextIO.stdOut, s)

val clearScreen = "\027[2J"
val clearLine = "\027[2K"
val default = "\027[0m"
val hideCursor = "\027[?25l"
val showCursor = "\027[?25h"
val home = "\027[H"
fun fgRGB (r, g, b) =
  "\027[38;2;" ^ Int.toString r ^ ";" ^ Int.toString g ^ ";" ^ Int.toString b
  ^ "m"
fun bgRGB (r, g, b) =
  "\027[48;2;" ^ Int.toString r ^ ";" ^ Int.toString g ^ ";" ^ Int.toString b
  ^ "m"

fun randRange (min, max) rnd =
  trunc (real min + Random.random rnd * (real max - real min))

(* How long to delay between lines. *)
val delay = 0.1

val ctable = Array.fromList
  [ (14, 84, 63)
  , (243, 235, 196)
  , (184, 229, 57)
  , (8, 103, 180)
  , (69, 90, 218)
  , (192, 194, 217)
  , (240, 165, 113)
  , (79, 79, 228)
  ]

val width = let val p = Unix.execute ("/bin/sh", ["-c", "tput cols"])
            in valOf (Int.fromString (TextIO.inputAll (Unix.textInstreamOf p)))
            end

fun printLine a =
  let
    fun pixel x =
      let val (r, g, b) = (Array.sub (ctable, x))
      in fgRGB (r, g, b) ^ bgRGB (r, g, b) ^ " "
      end
  in
    out (concat (List.tabulate (Array.length a, fn i =>
      pixel (Array.sub (a, i)))));
    TextIO.flushOut TextIO.stdOut
  end

fun main args =
  let
    val _ =
      if length args > 0 andalso Int.fromString (List.nth (args, 0)) <> NONE then
        seed1 := valOf (Real.fromString (List.nth (args, 0)))
      else
        (seed1 := real (randRange (0, 100000) rnd0))

    val _ =
      if length args > 1 then
        seed0 := valOf (Real.fromString (List.nth (args, 1)))
      else
        (seed0 := real (randRange (0, 100000) rnd0))

    val rnd = Random.newgenseed (!seed0)
    val rnd1 = Random.newgenseed (!seed1)

    val ctable = Array.tabulate (8, fn i =>
      ( randRange (0, 255) rnd1
      , randRange (0, 255) rnd1
      , randRange (0, 255) rnd1
      ))

    val firstGen = Array.tabulate (width, fn _ => randRange (0, 7) rnd)

    val rule = Array.fromList
      [7, 1, 1, 1, 0, 3, 2, 2, 1, 3, 6, 1, 4, 6, 5, 5, 4, 7, 6, 6, 6, 0]

    fun newGen a =
      Array.tabulate (width, fn i =>
        if i = 0 then
          Array.sub (rule, Array.sub (a, i) + 2 * Array.sub (a, i + 1))
        else if i = width - 1 then
          Array.sub (rule, Array.sub (a, i) + 2 * Array.sub (a, i - 1))
        else
          Array.sub
            ( rule
            , Array.sub (a, i) + Array.sub (a, i + 1) + Array.sub (a, i - 1)
            ))

    fun loop state =
      ( printLine state
      ; Process.sleep (Time.fromReal delay)
      ; loop (newGen state)
      )

  in
    out hideCursor;
    loop firstGen
  end

val _ = main (CommandLine.arguments ())
