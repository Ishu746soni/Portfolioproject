import cv2
import os

# Define the directory for storing images
directory = 'SignImage48x48/'

# List of words to create folders for
words = ["Hello", "I Love You", "Yes", "No", "Pray", "Fine", "Where", "Why"]

# Create main directory if it does not exist
if not os.path.exists(directory):
    os.mkdir(directory)

# Create subdirectories for each word
for word in words:
    path = os.path.join(directory, word)
    if not os.path.exists(path):
        os.mkdir(path)

# Create 'blank' directory for images with no sign
blank_dir = os.path.join(directory, "blank")
if not os.path.exists(blank_dir):
    os.mkdir(blank_dir)

# Initialize webcam
cap = cv2.VideoCapture(0)

while True:
    _, frame = cap.read()

    # Count the number of images in each directory
    count = {word: len(os.listdir(os.path.join(directory, word))) for word in words}
    count['blank'] = len(os.listdir(blank_dir))

    # Draw ROI (Region of Interest)
    cv2.rectangle(frame, (0, 40), (300, 300), (255, 255, 255), 2)
    cv2.imshow("Data", frame)

    # Extract ROI
    roi = frame[40:300, 0:300]
    cv2.imshow("ROI", roi)

    # Convert ROI to grayscale and resize it to 48x48
    roi = cv2.cvtColor(roi, cv2.COLOR_BGR2GRAY)
    roi = cv2.resize(roi, (48, 48))

    # Capture key press
    interrupt = cv2.waitKey(10)

    # Check which key is pressed and save the image in the corresponding folder
    key_map = {
        'a': "Hello",
        'b': "I Love You",
        'c': "Yes",
        'd': "No",
        'e': "Pray",
        'f': "Fine",
        'g': "Where",
        'h': "Why",
        '.': "blank"
    }

    if interrupt & 0xFF in map(ord, key_map.keys()):
        key = chr(interrupt & 0xFF)  # Convert key press to character
        word = key_map[key]  # Get the corresponding word
        file_path = os.path.join(directory, word, f"{count[word]}.jpg")
        cv2.imwrite(file_path, roi)
        print(f"Saved: {file_path}")

# Release resources (this part will execute when the loop breaks)
cap.release()
cv2.destroyAllWindows()
