const fs = require('fs');
const https = require('https');

const jsonFilePath = '../../feed/releases.json';

function logError(message) {
    console.log(`::error ::${message}`);
    process.exit(1);
}

function startGroup(name) {
    console.log(`::group::${name}`);
}

function endGroup() {
    console.log('::endgroup::');
}

const verifyChecksums = (data) => {
    data.forEach(product => {
        startGroup(`Product Code: ${product.Code}`);
        product.Releases.forEach(release => {
            const downloads = release.Downloads;
            Object.keys(downloads).forEach(downloadKey => {
                const { Link, ChecksumLink } = downloads[downloadKey];
                const archiveName = Link.split('/').pop();

                https.get(ChecksumLink, (res) => {
                    let data = '';
                    res.on('data', (chunk) => {
                        data += chunk;
                    });
                    res.on('end', () => {
                        if (!data.includes(archiveName)) {
                            logError(`❌   Checksum does not contain archive name for ${archiveName}`);
                        } else {
                            console.log(`✅   Verified: ${archiveName}`);
                        }
                    });
                }).on('error', (err) => {
                    logError(`❌ Error fetching ${ChecksumLink}: ${err.message}`);
                });
            });
        });
        endGroup();
    });
};

fs.readFile(jsonFilePath, 'utf8', (err, data) => {
    if (err) {
        logError(`❌ Error reading file from disk: ${err}`);
    } else {
        const releasesData = JSON.parse(data);
        verifyChecksums(releasesData);
    }
});
