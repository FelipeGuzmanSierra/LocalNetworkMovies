# LocalNetworkMovies
Phoenix Server to stream video files through the local network.

## Folder structure
The folder should have one folder for each video where the `.mp4` file and the subtitles (`.vtt` or `.srt`) file should be.

```
// Example folder structure
videos_folder:
  video_1:
    video_1.mp4
    video_1.srt
  video_2:
    video_2.mp4
    video_2.vtt
  video_3:
    video_3.mp4
    video_3.srt
```

The system used by default the `.vtt` format for subtitles, but if a `.srt` file is added the program will format it to `.vtt`

## Installation
On the root folder of the project rename the `.env.example` file to `.env`:

```
mv .env.example .env
```

In the `.env` file, set the local folder path where the videos will be.

```
MOVIE_FOLDER_PATH=/videos_folder_absolute_path
```

Build the docker container (just the first time):

```
docker-compose build
```

For now one just execute the container:

```
docker-compose up
```

Access to the application on http://localhost:4000 or access through any device connected to the same network using your local IP: http://192.168.X.X:4000
