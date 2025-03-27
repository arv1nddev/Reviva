document.addEventListener('DOMContentLoaded', function() {
    // Add click event listeners to download buttons
    const downloadButtons = document.querySelectorAll('.download-btn');
    
    downloadButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            // You can add analytics tracking here
            console.log('Download button clicked:', this.classList.contains('android') ? 'Android' : 'Windows');
            
            // Optional: Show a thank you message or download started notification
            const platform = this.classList.contains('android') ? 'Android' : 'Windows';
            alert(`Thank you for downloading Reviva for ${platform}! Your download should begin shortly.`);
        });
    });
});
