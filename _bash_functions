#### Functions
# Convertit une vidéo au format Kidigo (VTech)
# Vidéo : AVI en format MPEG4 SP (XVID), résolution : 480 x 272
#         Video Codec : Xvid, Video Bitrate : 1024 ou moins
# Son : Audio Codec : mp3, Audio Bitrate : 96
#       chanels  : 2, S.Rate (Hz) : maximum 44100
# Sous-titres : désactivés
function conv2kidigo {
# ffmpeg -i <input> -s <taille wxh> -sn (désactive les sous-titres) -b:v <video bitrate> -b:a <audio bitrate> -c:v <codec video> -c:a <codec audio> <output>
    ffmpeg -i "$1" -c:v libxvid -s 480x272 -b:v 512k -sn -c:a mp3 -b:a 96k "${1%%.***}.avi"
}

